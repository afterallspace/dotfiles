# Status: CLOSED 2026-08-15 — the automation works, monitoring has been stopped

The branch is closed: telemetry collection has stopped, `bootlog.csv`,
`unlock.log`, `snapshots/` and `runs/` were deleted (summary below),
`bootcheck.sh` was switched to pure diagnostics, `nvpcf-session-unlock.sh` logs
only to the journal (`journalctl --user -u nvpcf-unlock.service`). The
monitoring tools (`monitor.sh`, `summary.sh`, `compare-boots.sh`) moved to
`archive/`. The unlock automation **stays enabled** — the lock is not cured, it
is suppressed.

## Final statistics for the entire observation period (Jul 21 — Aug 13)

From `bootlog.csv` (deleted, the numbers are recorded here):

- 42 measurements over 25 unique `boot_id`s: 20 GOOD / 22 BAD.
- All BAD ones predate the automation's deployment (Jul 25). After Jul 25 —
  **7 measurements over 6 boot_ids, all GOOD**, 1718–1732 MHz, 31–33.5 W.

From `unlock.log` (deleted): 77 session runs over Jul 22–Aug 13:

| Outcome | Total |
|---|---|
| `OK: already unlocked` | 52 |
| `OK: unlocked (attempt N)` | 3 |
| `FAIL: still locked after 3 attempts` | 9 |
| `FAIL: load did not land` (no verdict) | 5 |
| early log format (`session unlock`) | 6 |
| current format, no verdict recorded | 2 |

Of the 6 early-format records, 3 carry their own verdict (`✔ unlocked`,
`✔ already free`), the other 3 are cut off.

**All 14 failures were on battery (AC=0); on mains power there were zero
failures.** The last FAIL was on Aug 11 (a series of three battery sessions,
the third one unlocked).

> The numbers were checked against the last copy committed to git: `bootlog.csv`
> and `unlock.log` in the commit "add 2026-08-12 measurement run and unlock
> sessions", from where they can be recovered in full (find it with
> `git log -- debug/gpu/unlock.log`). For `bootlog.csv` the copy is complete. For
> `unlock.log` it holds 76 sessions and 51 `already unlocked`; the final 77 and 52
> include the Aug 13 20:34 session, which never made it into git.

## Driver 610.57.04 (updated Aug 11): the lock did NOT go away, but sessions are clean

After the update — 9 session runs (Aug 12–13), all `OK: already unlocked`,
including one session entirely on battery (Aug 13 20:34, AC=0, 1582 MHz). This
is a weak finding: the automation stayed enabled, the sample is small, and
"already unlocked" does not distinguish "the race was won by itself" from "the
EC is parked in STNM=3 from the previous session". Testing "the problem went
away on the new driver" requires:
`systemctl --user disable --now nvpcf-unlock.service`, 5–10 reboots with
`./bootcheck.sh` on each. Until that is done, leave the automation alone.

## Review 2026-10-21: driver 615.78.08, kernel 7.2 — the lock is alive, the service is needed

The question came up: "hasn't the problem gone away by itself, since no bad
boots are visible — maybe disable the service?" The answer from the journal
(`journalctl --user -u nvpcf-unlock.service`, kept since Sep 24, 45 boots):

| Period | Sessions | On AC | On battery: free | locked → service unlocked | locked → 3 attempts missed |
|---|---|---|---|---|---|
| Sep 24 — Oct 21 | 43 | 14, all free | 19 | 5 | 4 |
| of which on 615.78.08 (since Oct 10) | 22 | 5, all free | 9 | 4 | 3 |

(+1 battery session cut off before the verdict.)

**Reliable finding** (within one session, before/after): the lock exists on
615.78.08 — Oct 17 1267 → 1575 MHz, Oct 21 1207 → 1635 MHz after the service's
recipe. The journal of every boot still shows `PlatformRequestHandler failed to
get target temp / platform power mode from SBIOS`, the BIOS is the same — the
root has not changed. "No bad boots are visible" because the service
extinguishes them in the first minute of the session.

The picture repeats the August result: all locks are on battery, not one on AC
in a month. Caveat: on AC the service runs on every boot, so "free on AC" still
does not distinguish "race won" from "EC parked in STNM=3 by the previous run".
The "3 attempts missed" failures (1050–1260 MHz after the recipe at 53–60%
charge) look like a battery power limit, not a lock: the 1500 MHz threshold is
stricter on battery than it needs to be.

Decision: **the service stays enabled**, there are no file logs (journal only),
nothing to clean up. To be revisited after a BIOS update or if `FAIL`s appear in
the journal on AC.

---

# Archive: status during the active investigation

# Status: WORKING RECIPE CONFIRMED (Jul 22 09:41), root cause localized

The stable unlock recipe was reproduced 2 out of 2 on the stock ACPI table
(07:05 and 09:41 on Jul 22, the second time with a check after 10+ minutes):

    (stock boot, GPU under load, charger plugged in)
    sudo ./nvpcf-unlock.sh --stnm 3     # the watts do not change — this is normal
    ... ~15-20 seconds ...
    sudo ./nvpcf-unlock.sh --stnm 1     # 17 → 32 W, 1725 MHz, IT HOLDS

⚠ CRITICAL: all failed repeats of this same recipe ran on the "ACPI fix"
override entry — **our own table patch was breaking the stability of the
unlock**. The override entry is to be deleted; boot only from the regular entry.

Automation: the user unit `~/.config/systemd/user/nvpcf-unlock.service`
→ `nvpcf-session-unlock.sh` (loads the GPU, measures, when locked calls
`/usr/local/bin/nvpcf-boot-fix.sh` via sudoers) → log `~/.config/debug/gpu/unlock.log`.
Installation — see the "Deployment" section below.

## Deployment (one-time)

```fish
sudo install -o root -g root -m 755 ~/.config/debug/gpu/nvpcf-boot-fix.sh /usr/local/bin/nvpcf-boot-fix.sh
sudo mkdir -p /usr/local/share/nvpcf-fix
sudo cp ~/.config/debug/gpu/acpi/nvpcf-stnm.aml /usr/local/share/nvpcf-fix/
echo "afterall ALL=(root) NOPASSWD: /usr/local/bin/nvpcf-boot-fix.sh" | sudo tee /etc/sudoers.d/nvpcf-fix
systemctl --user daemon-reload && systemctl --user enable nvpcf-unlock.service
# remove the harmful override:
sudo rm -f /boot/loader/entries/zz-cachyos-acpifix.conf /boot/acpi-override.img
```

After a driver/BIOS update: re-verify the recipe by hand; a kernel change
requires nothing (dkms rebuilds acpi_call).

## Actual statistics (recalculated Aug 13)

The lottery is over. The "8–15% good boots" figure further down in this
document refers to the state **before** the automation and is outdated.

From `bootcheck.sh` (`bootlog.csv`) since Jul 25: **7 measurements over 6
different `boot_id`s, all `GOOD`**, 1718–1732 MHz, 31.1–33.5 W. The last `BAD`
was on Jul 22 19:50. It survived the kernel change 7.1.4 → 7.1.8 and switching
RTD3 to `Enabled (fine-grained)` on Aug 3.

From `unlock.log`, the entire observation period:

| Outcome | Total | Of which on AC=1 |
|---|---|---|
| `OK: already unlocked` | 47 | 37 |
| `OK: unlocked (attempt N)` | 3 | 1 |
| `FAIL: still locked after 3 attempts` | 9 | 0 |
| `FAIL: load did not land` (no verdict) | 5 | 0 |

**On mains power the automation never failed: 38 out of 38.**

The failures cluster in battery sessions, but that is a distribution, not an
established cause. The hypothesis "the clock on DC falls with the charge level"
was tested on Aug 13 and **refuted**: on Jul 22 `bootcheck.sh` gives 495 MHz at
93% charge, while on Aug 2 it gives 1732 MHz at 80%.

A failure is not final, a retry solves it. On Aug 11, three sessions in a row
started at 210 MHz (19:39, 19:49, 19:55): the first two gave `FAIL` after 3
attempts, the third unlocked on the first attempt to 1717 MHz. All three were
**entirely on battery**, the adapter was plugged in only at 20:44
(`ACPI: AC: AC Adapter [ADP1] (on-line)`), so power has nothing to do with it.
This is that same EC delay from the "Proven unlock recipe" section: a write to
STNM is not always accepted the first time.

---

⚠ The sections below are the investigation's history; some of the intermediate
"wins" in them were refuted, the top of the document is what's current.
Background — [INVESTIGATION.md](INVESTIGATION.md), measurements —
[DATA.md](DATA.md).

## Firmly established (survived all tests)

1. **The lock = boost clocks forbidden.** A locked card is pinned at 1327 MHz
   (the ceiling of the non-boost clocks); a free one reaches 1700–1732 MHz. The
   watts (17 versus 35) follow from the clocks. Throttle flags (0x1/0x4) are
   noise, not the cause.
2. `nvidia-smi -lgc` in the locked state breaks through to ~1500–1600 MHz /
   ~20 W — **a partial measure, +15–20% performance**, after that it hits the
   power budget.
3. The state is armed at GSP initialization and does not change by itself
   within a session.
4. Runtime unlock via the EC (writing STNM + _Q24 with STNM∈{1,3}) really does
   bring the card to 30–33 W, but from ~07:11 on Jul 22 the EC returns mode 2
   within ~2 s and the lock comes back. **The only stable success was 07:05 on
   Jul 22** (stock table, the sequence `--stnm 3`, then `--stnm 1`, under load,
   powerd running) — it held until the end of the session.
5. All ACPI-table hypotheses (NVPCF v1/v2, TGPU v3), powerd and "charging at
   boot" were refuted by interventional tests (see INVESTIGATION).

## Next steps by priority

1. **Reproduce the 07:05 success literally**: the regular (stock) boot entry,
   charger plugged in, glmark in the background, then exactly:
   `sudo ./nvpcf-unlock.sh --stnm 3` → pause → `sudo ./nvpcf-unlock.sh
   --stnm 1`. The difference from all of today's repeats: today everything ran
   on the override entry and/or with a single _Q24.
2. **The 580 driver branch without GSP**: `nvidia-580xx-dkms` (proprietary),
   `NVreg_EnableGpuFirmware=0`. All power policy moves from the GSP into the
   kernel — different code, different bugs. The most promising systemic move.
3. **A BIOS update** from a Windows image (XMAAD6B0P1717 is very old).
4. **A bug report to NVIDIA** — the dataset in this folder is unique in its
   completeness.
5. ~~Until it's solved, live like this: the reboot lottery with bootcheck
   (~8-15%) + `-lgc 1500,1725` in bad sessions (gamemode does this) + heavy
   games from Windows if desired.~~
   ⚠ **Outdated, recalculated Aug 13.** The automation settled the question: 38
   out of 38 on mains, 6 of 6 boots `GOOD` by `bootcheck.sh` since Jul 25.
   Numbers and sample — in the
   ["Actual statistics"](#actual-statistics-recalculated-aug-13) section.

---

# Archive: course of the second wave (for history; the conclusions below are partly refuted)

---

## The gist in one paragraph

Xiaomi's BIOS gives the video driver, via the ACPI device NVPCF (`\_SB.NPCF`),
a **broken power limit table** (TPP 15–20 W instead of a sane value, the
battery table is missing altogether). The GPU firmware (GSP) reads it once at
initialization. In parallel, the EC controller asynchronously fires the `_Q24`
event, which rewrites these same variables and commands the driver to re-read
the config. **The boot outcome is decided by a race:** if the GSP managed to
swallow the broken table with the boost controller enabled, the card is locked
at ~16 W; if the EC event managed to disable the controller first, the card
lives on honest vBIOS settings (35 W, cap of 50). Hence "a good boot in ~8% of
cases" and the uselessness of everything tried within a session — until Jul 21
nobody had pulled the only lever that works: EC events.

## Evidence

1. **The table was found in ACPI** ([acpi/ssdt16.dsl](acpi/ssdt16.dsl), table
   `NvdTable`): at boot the NPCF device sets `ATPP=0xA0` (=160/8 = **20 W** TPP
   on AC; with a different value of the config flag `PDFG`, 15 W) and `DTPP=0`
   (no DC table — literally the nvidia-powerd error "DC power limits table is
   not supported").
2. **The EC handler `_Q24`** (dsdt.dsl, EC query 0x24): depending on the EC
   register `STNM` (0x7E) it enables (`STNM==2`) or disables (`STNM==1/3`) the
   Dynamic Boost controller and sends `Notify 0xC0` to the PEGP and NPCF
   devices — a command for the driver to re-read the power config.
3. **Live experiment on Jul 21:** in a bad boot (16.9 W since the morning),
   after a series of EC events the cap moved to 22.3–23.5 W — exactly the +5 W
   CTGP offset of the `STNM==1` branch (`ACBT=0x28`). Later, with `STNM==3`
   (boost controller disabled) — **31.9–33 W with a 50 W cap**. This refuted
   "only a reboot cures it" and confirmed the mechanism.
4. The `PlatformRequestHandler ... NV_ERR_INVALID_DATA` errors and
   nvidia-powerd's complaints are present on every boot (good and bad) — they
   are the background of the broken firmware, not the trigger.

~~Correlation with the battery charge phase~~ — **refuted on Jul 22**: a bad
boot during active charging, 19.6 W at 73% (bootlog, check #8). Only the race
at startup decides the outcome.

## Proven unlock recipe (Jul 22, live experiment)

Key facts obtained through live experiments from a bad boot:

- **`_Q24` cuts both ways**: run with `STNM==3` (or 1) it disables the boost
  controller and unlocks (16.9 → 32.4 W / 1725 MHz observed live); run with
  `STNM==2` it enables the controller and **locks it back** (also observed).
  Never pull it blindly.
- **The EC applies a write to STNM with a delay and not always the first time**
  (it happened: two writes of "3" in a row, and a read still says "2"). That is
  why the write and the "kick" are separated into different methods: `\NVSW`
  (write only, table nvpcf-set.aml) and a bare `_Q24`.
- `\NVOF` (writing NPCF variables directly, bypassing the EC cycle) does not
  convince the GSP.

**The safe recipe** (= `sudo ./nvpcf-unlock.sh` without arguments): write 3
through `\NVSW` → poll STNM until confirmed (with retries) → pull `_Q24` only on
a confirmed 3. If the EC never accepted the 3, the script honestly refuses and
does NOT pull _Q24; the options are to retry later or suspend/resume. Leave the
EC parked in 3.

## Tools (all in ~/.config/debug/gpu)

| File | What it does |
|---|---|
| `nvpcf-unlock.sh` | **unlock without a reboot**: `sudo ./nvpcf-unlock.sh` (NVOF method), `--boost` (NVFX), `--q24` (stock EC handler) |
| `nvpcf-peek.sh` | live values of all the mechanism's variables; `--kick` pulls `_Q24` |
| `profile-sweep.sh` | a "profile → STNM → watts" map under load |
| `acpi/nvpcf-fix.dsl` | source of the curative SSDT (methods `\NVOF` and `\NVFX`), build: `iasl nvpcf-fix.dsl` |
| `acpi/nvpcf-fix.aml` | the compiled SSDT — nvpcf-unlock.sh loads it |
| `nvpcf-unlock.service` | a draft systemd unit for auto-unlock at boot (NOT installed — see below) |
| `bootcheck.sh` | boot verdict in ~25 s + a snapshot of the journal/parameters (now also records the charge phase) |
| `acpi/*.dsl` | decompiled ACPI tables (dsdt.dsl, ssdt16.dsl = NvdTable) |

Dependencies: `acpi_call-dkms` (installed, dkms rebuilds it for new kernels
automatically), the `acpi_configfs` module (part of the kernel), `acpica`
(iasl), `glmark2` + `nvidia-prime` for load.

## Procedures

### Card is capped (17 W, 17 FPS) — unlock without a reboot

```fish
cd ~/.config/debug/gpu
prime-run glmark2 --off-screen -b shading:duration=600 &   # load for monitoring
sudo ./nvpcf-unlock.sh            # wait for "after: … W"
# if that did not help:
sudo ./nvpcf-unlock.sh --boost
sudo ./nvpcf-unlock.sh --q24
```

Expectation: 30+ W after the unlock. Checking in a game is mandatory — glmark
and the game agree (verified), but the game makes the verdict.

### Quickly find out what state the card is in

```fish
cd ~/.config/debug/gpu && ./bootcheck.sh        # under load, ~25 s, writes to bootlog.csv
sudo ./nvpcf-peek.sh                   # without load: variable values
```
Reference points: ~16 W — locked; 22 W — half-free (CTGP +5); 30–35 W — free.
In the free state nvidia-smi showed a 50 W cap.

### Collect data if behavior has changed (BIOS/driver update)

1. `./bootcheck.sh` — a snapshot in `snapshots/`.
2. `sudo ./nvpcf-peek.sh` — compare the variables with this document (ATPP,
   DTPP, STNM, the NOPR gates).
3. If the BIOS changed, re-take the ACPI dump: `sudo acpidump -o acpi.dat &&
   acpixtract -a acpi.dat && iasl -d dsdt.dat && iasl -e dsdt.dat -d ssdt*.dat`
   (in acpi/; "Unterminated quoted string" on acpi.dat itself is normal, it is
   not a table). Look for `NPCF` and compare the ATPP/AMAT values and the `_Q24`
   logic.
4. Kernel journal: `journalctl -k -b 0 | grep -iE "nvrm|nvidia"` — are the
   PlatformRequestHandler errors still there? `journalctl -u nvidia-powerd -b 0`.

### Full rollback of everything

Everything unlock does lives until a reboot. To force it: reboot. To remove the
tools for good: `sudo pacman -R acpi_call-dkms acpica`, delete the service (if
it was installed), the ~/.config/debug/gpu directory — as you like.

## Addendum Jul 22: the EC re-latches the unlock

Final experiment: unlocking through "NVSW 3 → confirmation → _Q24" gives
30.9–32.4 W for exactly ~2 seconds, after which **the EC itself returns STNM=2
and locks back**. Stopping power-profiles-daemon and unbinding the bitland
driver do not help — the source of the rollback is inside the EC. In the
morning at 07:05 the same unlock held for minutes — the EC's behavior is
unstable (probably depends on its internal state / an event storm). Conclusion:
**runtime fighting with the EC is unreliable in principle; the reliable solution
is option 2 (table replacement).**

## Permanent solution — options in increasing order of radicalness

1. **The systemd unit `nvpcf-unlock.service`** — calls the unlock on every boot.
   It works only as far as the EC agrees not to re-latch (see the addendum
   above). A fallback.
2. **Replacing the NvdTable table through the initrd** — installed with one
   command: `sudo ./make-acpi-override.sh`. Verifying it applied:
   `journalctl -k -b 0 | grep -i "table upgrade"` and `./bootcheck.sh`.
   Rollback = pick the regular entry in the menu or delete
   /boot/acpi-override.img and /boot/loader/entries/zz-cachyos-acpifix.conf.

   **Patch v1 (0x1001, FAILED — an important result):** the closed `_DSM` gate
   (`If (Zero)`) gave a locked boot with the table replacement confirmed.
   Conclusion: "the channel is silent" ≠ "freedom" — without an NVPCF response
   the GSP enables the boost controller by default and sits at the base ~17 W.
   **The resulting model:** LOCK = boost controller enabled (broken without a
   working Dynamic Boost, stuck at the base TGP ≈ 17 W); FREEDOM = controller
   disabled → static vBIOS TGP of 35 W. A good boot = the GSP read the table at
   a moment when DBAC/DBDC were 0 (the EC managed to run _Q24 with STNM≠2 before
   GSP init) — hence the ~8%.

   **Patch v2 (0x1002, current):** the gate is restored, but sub-func#2 always
   answers "controller disabled": `PC02 = Zero` (was `DBAC|DBDC<<1` — the source
   of the lock), `TGPA = Zero`, `TPPA = 45 W`. Whatever the EC writes to the
   variables and whenever the GSP reads the table — at boot or on Notify — the
   answer is always the same: boost disabled, no limits. The lock becomes
   impossible by construction.
3. **A Xiaomi BIOS update** (current XMAAD6B0P1717 from 12/2022) — it might fix
   the table. Can be checked only from Windows (an image on an external SSD).
4. **Bug reports**: NVIDIA (forums.developer.nvidia.com, Linux section) — the
   GSP should not swallow a 20 W TPP without validation and should survive the
   race with the EC; Xiaomi — the table itself is broken. There is enough
   material in this folder.

## What remains to be checked (validation)

- [x] `nvpcf-unlock.sh` pulls the card out of a **fresh bad boot** —
      CONFIRMED on Jul 22 (16.9 → 32.4 W, the "NVST 3 twice" recipe).
- [x] What clicked on the evening of Jul 21 — the EC mode change (STNM→3), now
      reproducible programmatically.
- [ ] Whether the unlocked state survives suspend/resume.
- [ ] Statistics: ~10 boots with bootcheck (it now records the charge phase) —
      confirm/refine the correlation with the battery.
- [ ] Stability of the 50 W cap in a long gaming session (temperatures were
      59–62 °C — a wide margin below 97).

## Risks and "what can break"

- **A reboot** resets everything: both the lock and the unlock. It is a race on
  every startup until option 1 or 2 is installed.
- **An NVIDIA driver update** may change GSP behavior (in either direction).
  After an update — `./bootcheck.sh` and, if needed, re-validating the unlock.
- **A BIOS update** will replace the ACPI tables — re-take the dump, compare
  NPCF.
- **A kernel update** is harmless: dkms rebuilds acpi_call automatically,
  acpi_configfs is part of the kernel.
- The NVOF/NVFX methods **write nothing to the hardware**: they change ACPI
  variables in RAM + notify the driver. vBIOS, EC and NVRAM are not touched.
  Hardware limits (50 W maximum, thermal thresholds of 97/100 °C) are baked into
  the vBIOS and GPU firmware and stay in force — this mechanism cannot go outside
  the factory envelope.

## Open oddities (not blocking, but keep in mind)

- Writing `performance`/`balanced-performance` to
  `/sys/class/platform-profile/platform-profile-0/profile` → EOPNOTSUPP, while
  `low-power`/`balanced` "get written" but do not change STNM. The p-p-d
  profiles on this machine are decorative as far as the GPU mechanism goes.
- `ucsi_acpi: bogus connector number in CCI: 2` — constant noise from the broken
  UCSI in the firmware; probably related to the EC's general brokenness.
  **Analyzed Aug 13**, no longer an "oddity": see
  ["UCSI: log storm"](#ucsi-log-storm-analyzed-aug-13).
- The good 13:03 session had a 35 W limit, the unlocked evening one had 50 W:
  there are at least two "free" states. Both are playable (35 W is enough).

## UCSI: log storm (analyzed Aug 13)

Trigger: the GNOME session crashed from OOM, and while going through the journal
it turned out that `ucsi_acpi USBC000:00: bogus connector number in CCI: 2` is
not background noise but the bulk of the journal. The analysis of the crash
itself has nothing to do with UCSI.

### What is established (reliable, within one session)

- **This is not "bursts when the charger is plugged in"**, as `DATA.md` says. An
  even 1 Hz stream, 2 lines per cycle (intervals of 0.215 s and 0.837 s),
  ≈1.9 lines/s. Over one boot (14 h) — **27,005 lines**, the on-disk journal
  bloated to 234 MB.
- **It does not start at boot.** Boot at 19:58, first line at 20:54 — 56 minutes
  later, with not a single other event in the journal at that moment.
- **It survives sleep.** The gap 21:21 → 06:52 is exactly s2idle; after waking
  the stream continued at the same rate and is still going.
- **The firmware signals connector #2, which does not exist.** Exactly one port
  is listed (`/sys/class/typec/port0`), physically there are two. The driver
  discards the event and exits without acknowledging it, and the firmware raises
  it again. Hence an undamped loop rather than a one-off burst. (The mechanism is
  a reasonable reconstruction from behavior, not verified by reading the kernel
  source.)

### UCSI data is useless — tested, not assumed

| Source | Value | Verdict |
|---|---|---|
| `ucsi-source-psy-*/online` | `0` | lies, the adapter is plugged in |
| `ucsi-source-psy-*/voltage_now`, `current_now` | `0` | empty |
| `ucsi-source-psy-*/charge_type` | `N/A` | empty (see `../battery/BATTERY.md`) |
| `typec/port0/power_operation_mode` | `default` | **lies** |

The key check: `power_operation_mode = default` means "default 5 V USB", that
is no more than 15 W. At the same moment `ADP1/online = 1`,
`BAT0/status = Charging`, `BAT0/power_now = 22.2 W` — **the battery alone takes
more than the port supposedly can deliver**, not counting the platform. The
field is unreliable.

Side result: on this line `powercheck.sh` printed
"⚠ ONLY default 5 V USB — PD NOT negotiated!" — that is, **it gave a confident
false verdict on every run**, exactly the case convention #5 was written
against. Fixed Aug 13: the warning is printed only if the draw confirms it
(< 15 W), otherwise it honestly reports that the field lies.

### Why it cannot be cured

- **Firmware.** BIOS `XMAAD6B0P1717` from 2022-12-13, Xiaomi has released no
  updates. The same root as the whole branch.
- **`dyndbg` will not help.** The message is printed through `dev_err`
  (KERN_ERR), and kernel dynamic debug controls only `pr_debug`/`dev_dbg`.
- **A journald limit will not do.** `RateLimit*` would apply to all kernel
  messages at once and start swallowing the `NVRM` lines — the very ones this
  whole branch rests on. The cure is worse than the disease.
- So what remains is unloading the module. There is nothing to lose: all it
  provides is zeros, `N/A` and one unreliable field.

### What unloading does NOT break

Charging and the PD contract are negotiated by the EC/PD controller itself in
hardware; UCSI is only a reporting interface for the OS. After the blacklist,
`ADP1` (the fact of the adapter being connected) and all of `BAT0` remain — that
is, the entire reliable part of the power path and the entire battery branch.
`thunderbolt` is a separate PCI driver, does not depend on UCSI, docks and USB4
are not affected.

Gone: `/sys/class/typec/port0` (4 fields, one of which lies) and
`/sys/class/power_supply/ucsi-source-psy-*` (all zeros).

### Recipe

`ucsi_acpi` does not end up in the initramfs (`MODULES=()`, `autodetect`, it has
nothing to do with mounting the root), so, unlike `nvidia` and `nvme_core`,
`modprobe.d` works here and the bootloader does not need touching.

```bash
# test in the current session, fully reversible:
sudo modprobe -r ucsi_acpi

# make it permanent:
echo 'blacklist ucsi_acpi' | sudo tee /etc/modprobe.d/ucsi-blacklist.conf

# roll back:
sudo rm /etc/modprobe.d/ucsi-blacklist.conf && sudo modprobe ucsi_acpi
```

Checking the effect: `journalctl -k --since "-60s" | grep -c "bogus connector"`
before and after — it was ≈114 per minute, it should become 0.
