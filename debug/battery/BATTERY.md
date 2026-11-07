# Battery wear — Xiaomi Book Pro 16 2022

Started 2026-08-03. The branch is active, no conclusion yet.

## Symptom

The firmware shows **39.0% wear**. From the owner's memory it was ~31% in March
2026, so about +8 pp in five months. The machine was bought in December 2023 —
about 2 years 8 months of use.

```
design capacity : 70.00 Wh
actual          : 42.71 Wh
lost            : 27.29 Wh
```

Battery SUNWODA R15B07W, Li-ion, 2 cells (`voltage_min_design` 7.72 V).

## What is established (2026-08-03)

**The energy counter does not lie grossly.** `./batcheck.sh watch 30` on the
charger: a power integral of 0.093 Wh versus `energy_now` growth of 0.093 Wh,
**a discrepancy of 0.3%**. The controller's instantaneous energy accounting is
consistent.

⚠ This does **not confirm** the wear figure. `energy_full` is not a measurement
but the controller's learned estimate of full capacity, recalculated on full
charge/discharge cycles. The consistency of the instantaneous counter does not
verify it.

**The cycle count is unavailable.** `cycle_count` = `-1`, `upower` shows
`charge-cycles: N/A` — the firmware does not report it. Without it you cannot say
whether the wear comes from mileage or from storage conditions.

**There is no charge limit anywhere.** Checked:

| Where I looked | Result |
|---|---|
| `/sys/class/power_supply/BAT0/` | neither `charge_control_*` nor `charge_behaviour` |
| `/sys/class/firmware-attributes/` | the directory does not exist at all |
| ACPI dumps (`../gpu/acpi/*.dsl`) | ~~no charge limit method~~ — **a mistake, corrected Aug 5**, the method exists: `\_SB.PC00.WMID.WMAA` in `ssdt8.dsl`. See [the section below](#charge-limit-investigation-closed-2026-08-05) |
| `/sys/module/{redmi_wmi,bitland_mifs_wmi}/parameters/` | no directories — the modules have no parameters at all |
| `find /sys/devices/platform -maxdepth 4` for `charge`/`batt` | the only match is `ucsi-source-psy-*/charge_type`, and even that is `N/A` |

The `charge_type` found belongs to the USB-C source, not the battery: it is a
read-only field describing the type of charging from the adapter, and the firmware
does not even fill it in (`N/A`) — the broken UCSI again.

⚠ Be careful searching `/sys`: a recursive `grep -r` over `/sys/devices/platform`
hangs the CPU for tens of minutes (verified Aug 3 — the process held all 16
threads at 100%). Search only with `find` by name, with `-maxdepth` and under
`timeout`, without reading file contents.

The `BCLM` symbol found in `ssdt19.dsl` is **a false lead**: it is a field of the
Intel graphics OpRegion structure (next to `BCLP`, `CBLV`, `ALSI`, `PFIT`), that
is, backlight brightness control, not charging.

So from Linux there is **nothing** to limit charging to 60-80% with. The battery
constantly stays near the upper bound — the machine is almost always on the
adapter.

> ⚠ The "nothing" conclusion was confirmed on Aug 5, but **the reasoning above was
> wrong**: we searched for the words `charge`/`BCLM`, while the interface is called
> `WMAA` and it is in the dumps. The analysis is in the section
> ["Charge limit: investigation closed"](#charge-limit-investigation-closed-2026-08-05).

**The BIOS has never been updated:** `XMAAD6B0P1717` dated **2022-12-13**. The same
root as in [the main investigation](../gpu/SOLUTION.md): the SBIOS returns garbage.
That also covers `ucsi_acpi USBC000:00: bogus connector number in CCI: 2` — the
broken UCSI, because of which the power source's parameters cannot be read
(see `../gpu/DATA.md`).

## CALIBRATION RESULT (2026-08-03)

The cycle was done: 100% → 8% in 2.2 h, 801 samples, a depth of 92%.

```
delivered by power integral : 35.97 Wh
by the energy_now counter   : 37.44 Wh   (discrepancy 4.1%)
extrapolated to 100%        : 39.1 Wh
average power               : 16.13 W
```

**The controller re-learned and revised the capacity DOWN:**

| | before the cycle | after the cycle |
|---|---|---|
| `energy_full` | 42.71 Wh | **40.62 Wh** |
| wear | 39.0% | **42.0%** |

**Hypothesis 3 is refuted.** It was assumed that the estimate was too low and would
rise after a full cycle. It was **too high** and went down by 2.09 Wh. The
measurement (39.1 Wh) is even slightly below the firmware's new estimate.

### The main consequence: the battery did not degrade in two weeks

[../gpu/DATA.md](../gpu/DATA.md) records **40.5 of 70.0 Wh = 58% of factory** for
Jul 21-22. Now, after calibration — **40.62 Wh, 58.0%**. Practically the same
number.

So the morning's 42.71 Wh was not "the battery recovered" but **the estimate
drifting up** over two weeks of small shallow cycles on the adapter. A deep
discharge returned the truth to the counter.

Hence the reassessment of the original alarm too. "31% in March versus 39% in
August" are two **uncalibrated** readings taken under unknown drift conditions.
The rate of degradation cannot be computed from them: the spread of the estimate
itself, as now measured, reaches 3 pp. The real figure today is **42% wear**,
worse than it seemed this morning, but with no evidence of acceleration.

The correct conclusion: what is alarming is not the rate but the level itself. And
further tracking should go by `batlog.csv` from this calibrated point.

### Trend from the calibrated point (updated 2026-10-21)

After Aug 3 the log was not being updated: `batcheck.sh` was run by hand and was
forgotten about. Since Oct 21 the snapshot is written by the user timer
`batlog.timer` once a day (`Persistent=true` catches up on a miss after a
shutdown), the units are in `~/.config/systemd/user/batlog.{service,timer}`.

| date | `energy_full` | health | wear | source |
|---|---|---|---|---|
| Jul 21–22 | 40.5 Wh | 58% | 42% | `../gpu/DATA.md` |
| Aug 3 after calibration | 40.62 Wh | 58.0% | 42.0% | the cycle above |
| Sep 30 | 42.2 Wh | 60% | 40% | measured when the laptop was opened (touchpad), no calibration — upward drift |
| Oct 21 | 39.97 Wh | 57.1% | 42.9% | `batlog.csv` |

Over 2.5 months from the calibrated point: −0.65 Wh, +0.9 pp of wear — within the
spread of the estimate itself (up to 3 pp, see above). **There is no acceleration**,
the battery has held at ~57–58% health since July.

⚠ Resources shows **health** ("Battery health", 57%), not wear. On Oct 21 this was
read as "wear rose to 57%".

## Battery life: +62 minutes after the RTD3 rollback (Aug 3)

Half an hour on battery under normal work after enabling Runtime D3
(`run_20260803-165800.csv`, 180 samples, counter discrepancy 1.2%):

| | average power | battery life at 40.6 Wh |
|---|---|---|
| before (Aug 3 discharge, 2.2 h) | 16.13 W | 2.52 h |
| after | **11.45 W** | **3.55 h** |

Savings of 4.68 W — 29% of the machine's consumption. It matches the dGPU's idle
draw, measured separately before the rollback (5.05 W). Details in
[../gpu/INVESTIGATION.md](../gpu/INVESTIGATION.md) §12.

Less draw means less heat next to the battery, so this also works against
degradation, although that contribution cannot be measured separately.

## Degradation hypotheses

None is tested, ordered by plausibility.

1. **Constantly staying at 100% on the adapter.** The classic Li-ion killer: high
   SoC + heat. Made worse by there being nothing to set a limit with.
2. **Thermal load from games.** The battery sits next to a 35 W card and the CPU;
   the sessions are long.
3. ~~**The `energy_full` estimate drifted** to the pessimistic side.~~
   **REFUTED by the Aug 3 calibration** — there was drift, but in the opposite
   direction: the estimate overstated capacity by 2.09 Wh. See the section above.

## How to really check: the calibration cycle

The only way to find out the real capacity is to measure how much the battery
really delivers under load from full charge to cutoff.

This is a **one-time** procedure, not a weekly one, and it takes not an hour but
the entire discharge.

```fish
cd ~/.config/debug/battery
# 1. charge to 100%, wait for status=Full
./batcheck.sh                      # record the point
# 2. unplug the adapter and work until cutoff, without plugging it back in
./batcheck.sh watch 21600          # 6 h with margin, can be interrupted with Ctrl+C
# 3. charge back to 100% without interruption
./batcheck.sh
# 4. analyze the run (mandatory if the machine died by itself)
./batcheck.sh sum runs/run_*.csv
```

How long to wait at a capacity of 42.7 Wh: at 10 W (browser, editor) about 4.3
hours, at 15 W 2.8 hours, at 25 W (a game) 1.7 hours. A game drains it faster, but
then consumption jumps around and the average power is less representative.

**Discharge depth matters more than duration.** `sum` refuses to estimate capacity
if the discharge was less than 50% — extrapolating from a small depth lies. An hour
of discharge gives 20-25%, which is not enough for an estimate, let alone for
re-learning by the controller.

Read it like this: if the delivered energy scaled to 100% is ≈ 42.7 Wh, the wear is
real, 39% is the truth. If noticeably more (say, 50+), the `energy_full` estimate
is too low, and after a full cycle the controller will raise it.

A full cycle also lets the controller re-learn — it is both a check and the only
available "cure" for the readings.

⚠ The machine will go to sleep or hibernation at critical charge — this is normal,
the data will not be lost: `watch` writes a line to `runs/` on every sample, not at
the end. After waking, analyze with `sum`.

⚠ A deep discharge is itself harmful to Li-ion. Do it **once** for the measurement,
do not make it a practice.

## Charge limit: investigation closed (2026-08-05)

**Result: a charge threshold on the TM2121 is unreachable. Not because of Linux —
the firmware does not have this function.** The SMI handler accepts the call and
does not implement it.

The branch is closed, but the Aug 3 conclusion ("the ACPI dumps have no such
method") turned out right in outcome and wrong in reasoning — the interface is in
the dumps, we just searched for the wrong word.

### Confirmed by measuring the current (2026-11-07)

A check that August never did: write the limit and watch whether charging stops.
In August `chargelimit.sh set` died on its status check before sending a non-zero
code, so "not implemented" rested only on the handler's silence. The prompt was
[XIAOMI-battery-limiter.rc](https://github.com/AlekseyIrlik/XIAOMI-battery-limiter.rc),
the Arch Wiki recipe for the RedmiBook Pro 16 2025 rewritten in Rust.

The same calls byte for byte, with the adapter plugged in, sent with
`archive/chargelimit.sh raw`:

```
SET 0x10/02 code 0x01 (80%)   OUT 00 10 02 00 01 00 00 00 … fb
GET 0x10/02                   OUT 00 10 02 00 00 00 00 00 … fa
GET 0x10/02                   OUT 00 10 02 00 00 00 00 00 … fa
```

**The limit has no effect, a reliable finding** (one session, nothing rebooted).
Charge went from 78% through 80% to 82%, status `Charging`, 14.4 W still
flowing. The firmware keeps nothing either: right after writing code `0x01` the read
returns the `0x00` that was sent with it, not the stored code.

⚠ **Correction to the sections below.** `OUT[k] = IN[(k+2) mod 32]` is probably not a
defect. It matches the "echo dialect" that
[XiControl](https://github.com/Oksion/XiControl/blob/main/docs/01-wmi-protocol.md)
documents on the TM2113 (Redmi Book Pro 15 2022): no status byte, `OUT[1]` echoes the
command, `OUT[2]` the argument. Group `0x10` is not implemented there either, and the
owner of that machine confirmed it. So "no `0x80`/`0xE0` was ever written" does not
show a dead handler by itself, and the current is what closes this question.

To re-check on a new BIOS: charge below the limit, adapter in, the three calls above,
then watch `status` and `power_now`. Undo with `raw 0xFB 0x10 0x02 0x00`, twice.

### What was wrong with the original premise

An analysis done from Windows claimed that there is no `WMID` object, only `MIFS`,
and therefore the ArchWiki recipe (`\_SB.PC00.WMID.WMAA`) would not fit. This is
wrong: `MIFS` is the `_UID`, not the object's name.

```
Scope (\_SB.PC00) { Device (WMID) {
    Name (_HID, "PNP0C14")
    Name (_UID, "MIFS")
    Method (WMAA, 3, NotSerialized) { ... }
```
— [`../gpu/acpi/ssdt8.dsl:39`](../gpu/acpi/ssdt8.dsl)

Confirmed live: `/sys/bus/acpi/devices/PNP0C14:00/uid` = `MIFS`. The ArchWiki path
fits **literally**, including `PC00`.

### The protocol is fully decoded

The firmware's BMOF (`WQAB`, 1296 bytes, matches `/sys/.../bmof`) decodes to:

```
class MICommonInterface {
  [WmiMethodId(1)] void MiInterface([in] uint8 InData[32],
                                    [out] uint8 OutData[30],
                                    [out] uint16 ReturnCode);
};
```

The request buffer (the first 8 of 32 bytes matter):

| offset | meaning |
|---|---|
| `[1]` | operation: `0xFA` GET / `0xFB` SET |
| `[3]` | command: `0x10` = charge protection group |
| `[4]` | sub-function: `01` health, `02` limit, `03` zone, `06` adapter watts |
| `[6]` | value |

Response: `OUT[1]` = `0x80` supported / `0xE0` not, `OUT[6]` = value. The limit
values are codes, not percentages: `0`→100%, `1`→80% (legacy), `4`→80% (granular),
`5`→70%, `6`→60%, `7`→50%, `8`→40%. There is no code for 90%.

Sources of the decoding, checked against each other: the reverse engineering of
Xiaomi PC Manager in [XiControl](https://github.com/Oksion/XiControl)
(`docs/01-wmi-protocol.md`, `docs/12-charge-levels.md`), the upstream kernel driver
`bitland-mifs-wmi`, and `_WDG`/`WQAB` from this machine's `ssdt8.dsl`. The ArchWiki
recipe's bytes fit the same format — there `0xfa` is wrongly called "enable the
limit", although it is GET, that is, a read.

### The chain of checks: where exactly it breaks

Each link was checked separately, the conclusion is reliable — all within one
session, without reboots.

| Link | Result | Proved by |
|---|---|---|
| The method exists and can be called | ✔ | `_UID`=`MIFS`, BMOF, a response arrives |
| The write to shared memory arrives | ✔ | `CTID`=`0x4141`, `MTID`=`0x1` read back |
| The SMI trigger port is set | ✔ | `PSSP` = `0xB2` — the canonical APMC port |
| An SMI is really generated | ✔ | `MSR 0x34`: **+1 per call** against a background of `+0` on both sides |
| The handler writes a response | ✗ | not one `0x80`/`0xE0` over ~50 calls |
| A round-trip through `WMIB` preserves the data | ✗ | a rotation by 2 bytes, see below |

The response to **any** request is the request itself, rotated left by 2 bytes:

```
IN : 00 fa 00 aa bb 00 cc 00 … 00
OUT: 00 aa bb 00 cc 00 00 00 … fa      OUT[k] = IN[(k+2) mod 32]
```

This holds equally for meaningful commands (`0x08`, `0x0D`, `0x10`, `0x16`) and for
the knowingly nonexistent `0xAA`. All 32 bytes are intact, not one is replaced. A
handler that answers does not behave like this — it would at least set a status.

### Why this is not "we called it wrong"

The observed rotation is the sum of the write skew and the read skew, and it is the
write skew that must be compensated. So a sweep over **all 32** precompensation
positions was run: if the write gives a rotation by `a`, then with `n = a` a correct
request lands in memory. Not one of the 32 positions produced a response.

Only one case is formally not covered: the write shuffles with a **non-rotation**
permutation, the read does too, and yet their composition gives a perfectly clean
rotation by 2. This is far-fetched — both sides are served by the same field access
code in ACPICA, the only difference is the direction.

The remainder could be checked by reading physical memory, but `/dev/mem` refused
access at `0x44A61000`, although `ACPI NVS` is not System RAM and
`devmem_is_allowed()` should have allowed it (`STRICT_DEVMEM=y`,
`IO_STRICT_DEVMEM=y`, `lockdown` = `none`). The reason was not found. The second way
is a custom SSDT with byte access to the region, bypassing the broken 256-bit field,
modeled on `../gpu/acpi/nvpcf-*.dsl`. Not done: the cost is high, the expected
return is low.

Indirectly the conclusion is also confirmed from the Windows side: the limit
function appeared in Xiaomi PC Manager 4.2.0.932 and is declared for devices newer
than the 2022 model.

### Side findings

**1. A round-trip defect through `WMIB`.** The field is declared as 256 bits with
`AnyAcc` at an offset of 8 bits from the start of the region, and a "write → read"
pass does not preserve the data (a rotation by 2 bytes). Region: `SystemMemory`
`0x44A61000`, 42 bytes, lies in `ACPI NVS` right after the FACS table. ⚠ **Probably
a misreading, corrected Nov 7**: the rotation matches the firmware's echo dialect, see
"Confirmed by measuring the current" above.

**2. The `bitland-mifs-wmi` kernel driver lies instead of reporting an error.**
Because of the defect above it receives zeros and reports them as valid values,
since it **does not check the status byte** `OUT[1]`:

| What it shows | What it really is |
|---|---|
| `hwmon/bitland_mifs` → `0 °C` | no data (nearby `coretemp` gives 40 °C) |
| CPU/GPU/SYS fan speeds → `0` | no data |
| `gpu_mode` → `hybrid` | just index 0 |
| `kb_mode` → `off` | just index 0 |
| `platform_profile` → `balanced` | just index 0 |

A candidate for a bug report to the author (Mingyou Chen), modeled on
[`../gpu/BUGREPORT.md`](../gpu/BUGREPORT.md). Kernel 7.1.5.

**3. A trap: do not write to `kb_mode`.** The driver treats command `0x10` as "RGB
keyboard mode" and puts the value in byte `[4]` — the very one where Xiaomi has the
sub-function. So `echo fixed > kb_mode` is `SET 0x10/02 val=0`. On a machine with
working firmware this would remove the charge limit. Here it is harmless only
because the interface is dead anyway.

**4. `PSSP` = `0xB2`.** The firmware uses the standard software SMI port. The
`MSR 0x34` counter gives exactly +1 per call — a handy technique for checking
"does it arrive at all" in any future investigation on this machine.

### What this was obtained with

[`archive/chargelimit.sh`](archive/chargelimit.sh) — all of this was obtained with
it. It sits in the archive as a dead end, but it works: `diag`, `smi`, `mem`,
`rotsweep`, `calib`, `probe`, `raw`. It will come in handy if a new BIOS appears and
you want to re-check in ten minutes instead of reverse engineering it again.

## What can be done about the degradation

From Linux — almost nothing, there is no limit interface. What remains:

1. **Look in the BIOS** for a battery protection mode (Battery Protection /
   Conservation Mode). A 2022 BIOS, the probability is medium. The only untested
   path to a threshold left after Aug 5.
2. **Behaviorally**: do not keep it on the adapter for days at 100%. GNOME can
   notify, there is no automation.
3. **Update the BIOS** — there is a chance that a new version both adds a charge
   limit and fixes some of the ACPI garbage. It is also listed as an untested item
   in the main investigation. After Aug 5 this item became concrete: what needs
   fixing is not "ACPI in general" but the SMI handler of group `0x10` and the
   `WMIB` field. To check a new BIOS: `archive/chargelimit.sh diag` and `smi`.
4. ~~Set a limit through the `WMAA` ACPI call~~ — **closed Aug 5, confirmed by
   measuring the current on Nov 7**, the firmware does not implement the function.
   Analysis above.
5. **From outside the laptop**: a reminder to unplug at 80%, which is what XiControl
   falls back to on models without a limit, or a smart plug that really cuts the
   power at a threshold. Neither is set up yet.

**What really helped, unlike the limit:** the RTD3 rollback gave 16.13 → 11.45 W,
that is, +62 minutes of battery life (section above). Less draw means less heat next
to the battery. A charge limit, even if there were one, would give less. And 42%
wear is cured only by replacing the battery.

## The tool

```fish
cd ~/.config/debug/battery
./batcheck.sh                     # snapshot + a line in batlog.csv — THIS is the weekly one
./batcheck.sh watch 600           # watching, writes a run to runs/
./batcheck.sh sum runs/file.csv   # analysis of a saved run
```

**Weekly you only need the first one — it is instant.** It appends a line to
`batlog.csv`, from which a **trend** builds up, which does not exist yet: the
figures of 31% in March and 39% in August are from memory, not from measurements. In
a couple of months it will be clear whether degradation continues at the same rate.

`watch` is needed only for the calibration cycle and one-off checks — there is no
point in holding it for an hour every week.

About short runs: the discrepancy between the integral and the counter over less
than half an hour drowns in the quantization of `energy_now` (step ~1 mWh), and `sum`
honestly marks such runs as noise rather than a discrepancy.

## What's next

1. Keep accumulating `batlog.csv` — without a trend any conclusions about the rate
   of degradation rest on two memories. Since Oct 21 it accumulates by itself
   (`batlog.timer`); to see the trend, use `./batcheck.sh` or the tail of the CSV.
   Lines between full cycles drift up, the points right after a deep discharge are
   the reliable ones.
2. Run the calibration cycle when you don't mind losing half a day of battery life.
3. Check the BIOS for a charge limit. After Aug 5 this is the only untested path:
   ACPI/WMI is closed for good.
4. File a bug report on `bitland-mifs-wmi` — the driver reports zeros as valid
   values without checking the status byte. The material is gathered in the section
   on closing the branch.
