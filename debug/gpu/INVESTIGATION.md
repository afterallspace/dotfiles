# Course of the investigation: all hypotheses and how they ended

Chronology and analysis. For each hypothesis: what was assumed, how it was
tested, what came out. Read before proposing a new one: half of the "fresh
ideas" are already closed here.

---

## Chronology

| When | What |
|---|---|
| Jul 19 15:52 | Clean CachyOS install |
| Jul 19 evening | **Games run fine, 55-60 FPS in 4K** |
| Jul 20 18:01 | System cleanup, 64 packages removed (nothing graphical) |
| Jul 20 18:28 | blur-my-shell installed |
| Jul 20, during the day | **FPS fell to 17 and did not recover** |
| Jul 20 | ~10 reboots, cold start, draining to zero — did not help |
| Jul 21 07:00–12:00 | First measurements. All invalid (a tool bug) |
| Jul 21 13:03 | **The only successful measurement: 34.9 W, 56 FPS** |
| Jul 21 13:29 → 16:16 | ~10 reboots, all bad |

Before that: 3 months on CachyOS + Hyprland, the symptom appeared in the last 3
weeks and gradually got more frequent.

---

## Closed hypotheses

### 1. Power budget: the CPU takes watts from the GPU

**Idea.** The CPU's PL1 is set to 52 W against a rated 28, PSYS 56 W, Dynamic
Boost is broken. The calculation: 52 (CPU) + 15 (GPU) + 33 (charging) = 100 W =
the adapter's rating. The arithmetic added up suspiciously exactly.

**Test.** Measurement in a bad run: **CPU 14.3 W**, PSYS **42.9 of 56**,
GPU 16.0 W. A spare 13 W lies untouched.

**Result.** CLOSED. The CPU physically does not take its 52 W — PSYS cuts the
package at ~35 W before that. Nobody is taking anything from anybody. Plus, the
drop after 2-3 seconds is too fast for thermal throttling (tau PL1 ≈ 28 s).

### 2. Battery charging eats the adapter's budget

**Idea.** A discharged battery draws 30+ W for charging, the adapter hits
100 W, the EC cuts the video card.

**Test.** Runs at 63%, 68%, 75%, 84% and 100% charge.

**Result.** CLOSED. The numbers are identical regardless of charge.

### 3. blur-my-shell and GNOME extensions

**Idea.** Installed Jul 20 at 18:28 — right on the day of the breakage. It keeps
blur actors on the screen, so Mutter cannot drop the compositor out of the path
during a fullscreen game (unredirect), and each frame goes through full
compositing.

**Test.** All GNOME extensions disabled.

**Result.** CLOSED. The numbers did not change.

### 4. 2.5× fractional scaling at 4K

**Idea.** A heavy compositing path, XWayland games pay for the rescaling.

**Result.** CLOSED. 250% was the original **working** configuration. At 200%,
125%, 100% and in 1080p FPS rises but stays below the reference — so the sag is
uniform, not tied to resolution.

### 5. Regression from a package update

**Test.** `pacman.log` for Jul 19-21.

**Result.** CLOSED. **Zero updates** between the working evening and the
breakage. The software is bit-for-bit the same. Removing 64 packages on Jul 20
touched nothing graphical or power-related.

### 6. The game runs on the integrated Intel

**Idea.** Vulkan by default hands out device 0 = Iris Xe, NVIDIA only second.
17 FPS in 4K is just what you would expect from Iris Xe.

**Test.** `nvidia-smi` during the game.

**Result.** CLOSED. `INSIDE.exe` is in the GPU's process list, holding 1.4 GB of
video memory. The game is on the dGPU.

### 7. Memory starvation

**Idea.** RAM 13.0/15.3 GB, swap 9 GB, ~21 GB swapped out during the session.
The GPU shows 100% utilization at 7 W — "busy waiting" rather than computing.

**How it fell apart.** The conclusion was built by **stitching together two
incompatible snapshots**: `nvidia-smi` showed `P5 / 0% / 7 W` because the game
was minimized and paused, while "GPU 100%" came from MangoHud at a different
moment. A methodological error.

**Result.** CLOSED. In a bad run RAM is 7.2/15.3, swap is empty — and still
16 W.

### 8. GPU acceleration of Steam's web views

**Idea.** `steamwebhelper` holds 1.0-1.4 GB of the four GB of video memory.

**Result.** CLOSED. The reference run at 34.9 W ran **with** acceleration
enabled, `steamwebhelper` held ~968 MB and did not interfere. No need to disable
it — without it the Steam UI lags unbearably.

### 9. Broken Dynamic Boost / nvidia-powerd

**Idea.** `nvidia-powerd` on every boot writes
`Failed to get SysPwrLimitGetInfo`, `DC power limits table is not supported`,
a cyclic `JPAC is not created`. That is what does the choking.

**Test.** `systemctl stop nvidia-powerd`, measure in the game.

**Result.** CLOSED. **16.0 W, 1137 MHz — matches the previous run to the
tenth.** The daemon only complains in the log, it makes no decisions. The
choking comes from the kernel module or the GSP firmware.

### 10. A race at initialization (three sub-hypotheses)

**Idea.** A machine diff of the journals gave two differences between a good and
a bad boot:

```
GOOD:  nvidia-drm on minor 1, i915 on minor 2, WMI = Bitland MIFS
BAD:   nvidia-drm on minor 2, i915 on minor 1, WMI = Redmibook
```

The cause was found: **two modules claim the same WMI GUID** —
`alias wmi:46C93E13-EE9B-4262-8488-563BCA757FEF` exists for both `redmi_wmi` and
`bitland_mifs_wmi`. Whoever gets there first takes it.

Then it turned out that what matters is not the order but the **overlap**: in a
good boot the NVRM → nvidia-modeset → nvidia-drm chain takes 54 ms and finishes
314 ms before i915 starts; in a bad one nvidia-modeset is delayed by 355 ms
instead of 24 and starts in the same millisecond as i915.

**Test.**
- A: `blacklist redmi_wmi` → the marker stuck to `bitland`, the watts did not
  rise.
- B: `MODULES=(nvidia …)` → changed nothing, `kms` was loading nvidia early
  anyway.
- C: removing `kms` from HOOKS → **gap of +5190 ms**, DRM order `nvidia-first`,
  WMI `bitland` — that is, **all three markers of a good boot reproduced at
  once**, and still bad.

**Result.** CLOSED entirely. The markers turned out to be coincidences.
⚠ The assessment over 1-4 boots is statistically weak, see the section on
methodology.

### 11. Charging state at boot time

**Idea.** A diff of `static.txt` from a good and a bad run gave **exactly one
difference**: `Charging 95%` → 34.9 W versus `Not charging 100%` → 16.0 W.
Everything else is identical to the letter. Mechanism: at 100% charge the EC
opens the charging circuit, the platform stops giving an unambiguous "on mains",
the driver takes the DC limits, and their table is broken.

The hypothesis explained the whole history: the first evening after install (the
laptop was charging), the breakage the next day (the battery reached 100%), the
uselessness of reboots.

**The first test was wrong.** The battery was changed *in the middle of an
already bad session*, even though we ourselves had proved the state is latched
at driver init. The test could not have given a different result regardless of
whether the hypothesis was true. The hypothesis had to be restored and
re-tested.

**Second test.** A reboot during active charging (97%), measured with the fixed
tool.

**Result.** CLOSED. 16.8 W.

### 12. Aggressive Runtime D3 (RTD3)

**Idea.** `/proc/driver/nvidia/params`: `DynamicPowerManagement: 2` —
fine-grained RTD3, the driver powers the card down at the slightest idle. The
card really does go to D3cold. If on some boots it comes out of the cycle with a
reduced TGP, that would explain the non-determinism.

**Test.** `nvidia.NVreg_DynamicPowerManagement=0` through the kernel command
line (it does not apply through `modprobe.d`, see pitfalls), confirmed by
`Runtime D3 status: Disabled`.

**Result.** CLOSED. 16.9 W.

**Postscript 2026-08-03: we forgot to roll the parameter back.** The hypothesis
was closed back on Jul 21, yet `nvidia.NVreg_DynamicPowerManagement=0` stayed in
`LINUX_OPTIONS` for more than two weeks. Discovered during a service audit.

The idle cost with RTD3 disabled:

| What | Value before the rollback |
|---|---|
| `Runtime D3 status` | `Disabled` |
| dGPU PCI power state | `D0` (never sleeps) |
| GPU idle draw | **5.05 W** at 0% utilization |
| Average machine power | **14.36 W** (374 discharge samples on Aug 3) |

So the idle card was eating more than a third of all consumption. With a
capacity of 42.7 Wh that is the difference between ~2.8 and ~4.3 hours of
battery life, plus extra heat next to the battery, whose wear is analyzed in
[../battery/BATTERY.md](../battery/BATTERY.md).

⚠ **The rollback is a step into the untested, not a return to the known.** All
39 valid `bootlog.csv` records (22 bad and 17 good) were taken with
`rtd3=Disabled`; the unlock recipe itself was developed with RTD3 already
disabled. There is no data on how `nvpcf-unlock.service` behaves with
`DynamicPowerManagement: 2`. So `./bootcheck.sh` is mandatory after the rollback,
and if things get worse — restore from `/etc/sdboot-manage.conf.bak`.

**Rollback result (first boot on Aug 3).** The fear did not come true, the
unlock survived enabling RTD3:

```
unlock.log        : clock under load: 1732 MHz → OK: already unlocked
Runtime D3 status : Enabled (fine-grained)
DynamicPowerManagement: 2
```

1732 MHz with a lock threshold of 1327 — the card is free. Watching
`power_state` through sysfs (not through `nvidia-smi`, which wakes the card)
showed real sleep: `D3cold` / `suspended`, cumulatively **262 s of sleep versus
155 s of activity** over the boot. Before the rollback
`runtime_suspended_time` was exactly `0` — the card never slept once.

The parameter was removed, `/etc/sdboot-manage.conf.bak` was kept in case the
rollback needs rolling back. Verified with `cat /proc/cmdline` — the parameter
is gone.

**The gain was measured (Aug 3, `battery/runs/run_20260803-165800.csv`).**
Half an hour on battery under normal work, 180 samples:

| | average power | battery life at 40.6 Wh |
|---|---|---|
| with RTD3 disabled (Aug 3 discharge) | 16.13 W | 2.52 h |
| with RTD3 enabled | **11.45 W** | **3.55 h** |

Savings of **4.68 W — 29% of the machine's total consumption, +62 minutes of
battery life.** It agrees with the card's idle draw measured before the rollback
(5.05 W): the difference went exactly where it was expected to. Over the same
boot the card spent 86% of the time asleep (44 min of sleep versus 7 min of
activity).

⚠ The comparison is not strict: the baseline was taken over 2.2 h, the check over
0.5 h, the load may have differed (instantaneous power in the run ranged from 4.8
to 48.6 W). But the match with the independently measured GPU idle draw makes the
conclusion reliable.

### 13. Power adapter and cable

**Idea.** A damaged cable or a degraded adapter cannot deliver the power.

**Result.** CLOSED. Three independent arguments:
- In all bad runs the flag is only `0x4 SwPowerCap` — software. The hardware
  `0x8 HwSlowdown` and `0x100 HwPowerBrakeSlowdown` never appeared, and it is the
  latter that means "the controller cut the supply".
- In the bad state PSYS is 42.9 W of the allowed 56 — the margin is unused.
- **In the good session total consumption was HIGHER** (≈50 W versus ≈30). A weak
  adapter would have failed the heavy session, not the light one.

Along the way: battery wear is **58% of factory capacity** (40.5 of 70.0 Wh). It
does not cause throttling but explains the symptom's progression — the battery
reaches "100%" twice as fast and sits longer in the state that was suspected for
a while.

### 14. PowerMizer in saving mode

**Idea.** `nvidia-settings` reports `GPUPowerMizerMode: 0` — adaptive mode.
Switching to 1 ("prefer maximum performance") should lift the limit.

**Result.** CLOSED, but tellingly: `nvidia-settings` reports
`assigned value 1`, and a read returns **0**. **The driver silently rolls back
the setting.** The power stayed at 16.7 W. The driver will not let itself be
controlled because it cannot get from the firmware the data for its power model.

### Other things closed along the way

| Hypothesis | Closed by |
|---|---|
| Overheating | 53-62 °C under load with a slowdown threshold of 97 |
| PCIe bus errors, Xid | not one AER, not one Xid in all the logs |
| PCIe as a bottleneck | Gen4 x4 = 63 Gbit/s, holds under load |
| Module/kernel mismatch | `vermagic` matches `uname -r` |
| Kernel 7.1.3 as a regression | several boots on LTS 6.18, all bad |
| The NVPCF table as the source of the lock (Jul 22) | patches v1 (gate closed) and v2 (controller always "off", TPP 45) were applied and verified by calling _DSM directly — the lock stays |
| Target temperature of 66 °C (Jul 22) | patch v3 (always 83 °C, visible in nvidia-smi) — the lock stays |
| nvidia-powerd as a "re-locker" (Jul 22) | daemon stopped + unlock → re-lock after ~2 s anyway |
| Charging at boot time, second round (Jul 22) | 14/14 in the journals, but the interventional test refuted it |
| Cold start with an EC reset (Jul 22) | a bad boot, the EC's behavior did not change |
| `NVreg_UsePageAttributeTable ignored` | a stock parameter from the package, does not exist in the open module |
| Raising the limit through `nvidia-smi -pl` | locked in the vBIOS |

---

## Methodological errors — our own, analyzed

They deserve a separate section: each one cost hours and led astray.

### Stitching incompatible snapshots

The conclusion "GPU 100% at 7 W = idling on memory" combined a MangoHud reading
from one moment and `nvidia-smi` from another, when the game was minimized and
paused (`P5 / 0%`). A whole hypothesis was built on this.
**Lesson:** take `nvidia-smi` without minimizing the game.

### A broken tool, three iterations

`loadtest.sh` produced empty data for five runs in a row: first `vkmark` ran
without `prime-run` and loaded the Intel; then with a wrong flag
`-b :duration=999`; then with `-p immediate`, which the card does not support —
and it crashed instantly. The output was silenced into `/dev/null`, so the error
was invisible.
**Lesson:** never silence the output of the tool you measure with.

### A tool that cannot reach the cap

`bootcheck.sh` gave verdicts for ten checks in a row based on `vkmark`, which
hits vertical sync and gives at most ~11 W — **below the 16 W cap**, so it could
not tell a good boot from a bad one in principle. Replaced by
`prime-run glmark2 --off-screen`, which gives 16.9 W and agrees with the game.
The old data is in `archive/bootlog-invalid.csv`.
**Lesson:** check an instrument for agreement with a reference before trusting
it.

### A test that could not show anything

The charging hypothesis was refuted by changing the battery state *in the middle
of an already bad session* — even though it had already been proved that the
state is latched at boot. The test would have given "bad" whether or not the
hypothesis was true. It had to be restored and re-tested properly.
**Lesson:** check the test plan against your own model of the phenomenon.

### Correlation without intervention (second wave, Jul 22)

A journal diff gave a perfect split: 2 good boots — `ADP1 off-line`, 12 bad —
`on-line`. 14/14, zero exceptions. A direct test (reboot with the charger
unplugged) — BAD on the very first attempt (#17 in bootlog).
**Lesson: on this machine even 14/14 is not a cause but the shadow of something
else. No correlation counts until confirmed by intervention.**

### Statistics at an 8% base rate

A good boot comes up in about 8% of cases. Tests over 1-4 boots do not
distinguish "did not help" from "got unlucky": even with a completely useless
intervention the chance of not seeing a good boot within 4 attempts is about
72%. All hypotheses that required a reboot (10, 11 and partly 12) were judged
this way and are therefore **weakly closed**.
**Lesson:** before going through hypotheses, estimate the base rate of the event.
