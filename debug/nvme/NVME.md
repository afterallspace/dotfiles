# Side branch: the NVMe Power Cycles counter

Started 2026-08-03. It came up during a routine drive health check and has **no**
direct relation to the FPS drop so far — kept separate so as not to clutter the main
investigation. The GPU unlock mechanism is described in
[SOLUTION.md](../gpu/SOLUTION.md), operations are in [OPERATIONS.md](../gpu/OPERATIONS.md).

## Symptom

`sudo smartctl -a /dev/nvme0n1` on a KINGSTON SFYRD2000G (FURY Renegade 2 TB,
firmware EIFK31.6):

```
Percentage Used:                 18%
Power Cycles:                    130,043
Power On Hours:                  6,107
Unsafe Shutdowns:                238
Data Units Written:              66,559,833 [34.0 TB]
Available Spare:                 100%
Media and Data Integrity Errors: 0
```

Two inconsistencies:

1. **130,043 power cycles over 6,107 hours of operation — 21 cycles per hour.** The
   machine does not power on that many times. The journal's whole available history
   has 11 boots and 24 suspend events.
2. **18% wear with 34 TB written.** The model's rated endurance is 2000 TBW, so the
   host has written 1.7% of the endurance, while the firmware shows 18%. A tenfold
   discrepancy.

The second is probably a consequence of the first: `Percentage Used` is computed from
real NAND cycles, and every power cycle brings housekeeping work by the controller
(cache flushes, garbage collection) that gets written to the cells.

## What is reliably verified (within a session)

All read-only, state as of 2026-08-03.

| What | Value | Conclusion |
|---|---|---|
| `power/control` (PCI) | `on` | runtime PM for the drive is **off** |
| `runtime_status` | `active` | |
| `runtime_suspended_time` | `0` | the drive has **never** entered D3 during this boot |
| `power_state` | `D0` | |
| `d3cold_allowed` | `1` | allowed, but not used |

So there is **no real power-off of the device**. The classic hypothesis "aggressive
PCI-PM powers the drive down" is closed.

## What is under suspicion

The drive lives in the non-operational APST states and in ASPM L1.2, and the firmware
apparently counts exits from them as power cycles.

| What | Value |
|---|---|
| `nvme_core.default_ps_max_latency_us` | `100000` (100 ms, APST on) |
| PS3 / PS4 power per the drive's spec | 0.062 W, entry 2500 us, exit 7500 us |
| `link/l1_1_aspm`, `l1_2_aspm` | `1`, `1` |
| `link/l1_1_pcipm`, `l1_2_pcipm` | `1`, `1` |

The sector format is 512 B, although the firmware supports 4096 and itself marks it as
faster (`Rel_Perf 1` versus `2`). This directly affects write amplification but has
nothing to do with the cycle counter. It can be changed only by a full wipe
(`nvme format -l 1`), that is, at the next reinstall.

## Link to the main investigation: not established

The temptation is there — same machine, same broken Xiaomi SBIOS, power again. But the
mechanism is different: the GPU is choked by `PlatformRequestHandler`/NVPCF, which is
arbitration of the platform power budget; the NVMe sits on a different controller with
its own PCI-PM policy. No shared registers were found between them.

So far this is **a coincidence, not a hypothesis**. It can be promoted to a hypothesis
if `power_cycles` growth turns out to differ between a good and a bad boot — then both
problems would have a shared platform trigger. This is a cheap check: `bootcheck.sh`
runs on every boot anyway, it is enough to take the counter alongside it.

## RESULT: the branch is closed, nothing is toggling

A measurement on 2026-08-03 showed that **right now the counter behaves perfectly**:

| moment | power_cycles | POH |
|---|---|---|
| `smartctl`, 08:48 | 130,043 | 6,107 |
| before-suspend | 130,043 | 6,108 |
| after-suspend | 130,044 | 6,108 |
| after-reboot | 130,045 | 6,108 |

Over an hour of normal work there is **no growth at all**. A sleep/wake cycle gives
exactly +1, a reboot exactly +1. That is exactly how much it should be.

From this it follows:

- **The APST/L1.2 hypothesis is closed.** APST works precisely at idle, and at idle the
  counter stands dead still. The firmware adds nothing.
- **The "something is toggling power" hypothesis is closed.** There are exactly as many
  real cycles as real events.
- **The link to the main investigation is closed.** There is nothing toggling: the
  current rate of accumulation is about zero. There is no point in checking the counter
  on a good and a bad boot.

Where the 130 thousand came from **cannot be determined from here**. They were gained
not now but in the past, in bursts: uniform accumulation would give 21 cycles per hour,
while the measured rate is near zero. The candidates are past OS installs (there were
several), a period with a broken suspend, a different BIOS version. The journal does not
keep that much, there is nothing to reconstruct it from. It has no practical
significance.

`unsafe_shutdowns` did not grow across a reboot (238 → 238) — the shutdown is clean.
`num_err_log_entries` grew a little (16567 → 16578): these are the same old
`Invalid Field in Command` from utilities, unrelated to data safety.

**What to do: nothing.** The drive is healthy, the 18% wear is static, spare is 100%,
`media_errors` is 0. All that remains is a semi-annual check of the `Percentage Used`
trend. The discrepancy of 18% versus 1.7% of the endurance written is explained by write
amplification (512 B sector, btrfs CoW, zstd) and the history of those very cycles — but
since the accumulation has stopped, it is a static fact.

## Measurement journal

**2026-08-03, 903 s of idle — INVALID, the result does not count.**
The script showed growth of 0 and the verdict "the counter is idle", but `power_cycles=0`
and an empty `pct_used` went to `nvmelog.csv`. So the second SMART snapshot was not read
at all, and the script took the emptiness for a zero. The cause: the 903 s interval
exceeded the `sudo` password cache timeout (900 s by default), the second
`sudo nvme smart-log` went to `2>/dev/null` and returned an empty string.

Fixed in `nvme-pmcheck.sh`: the sudo cache is kept alive by a background loop, every
snapshot is checked for parsability, on failure the script dies with a message and **does
not write a line to the log**. The measurement has to be retaken.

A moral for the pitfall collection: this machine has already had a case where a silent
default value produced a false conclusion. Any measurement here must be able to tell
"zero" from "could not read".

**2026-08-03, second attempt — the script died while parsing, the data was taken by
hand.** The protection against a format change fired on a format that had not changed:
`nvme-cli` pads keys with **tabs**, while the match was written for spaces (`^key *$`).
The test fixture was built from output pasted through the clipboard, where the terminal
had already expanded tabs into spaces — so the test passed, while on live output it
broke. Fixed by comparing the string after trimming `[ \t]`. A second defect surfaced
along the way: the background sudo refresh loop held stdout open, and the script's output
would have hung with `| tee`; the streams are now closed.

The numbers themselves from this attempt are valid and went into the result above.

## How to check

```fish
cd ~/.config/debug/nvme
sudo ./nvme-pmcheck.sh          # snapshot: counters + PCIe/APST state
sudo ./nvme-pmcheck.sh 600      # 10 minutes of idle, growth → nvmelog.csv
```

If the counter stands still at idle, it is being toggled by **events**, not time. Then
measure with marks before and after an event:

```fish
sudo ./nvme-pmcheck.sh --mark before-suspend
# close the lid / systemctl suspend, wake up
sudo ./nvme-pmcheck.sh --mark after-suspend

sudo ./nvme-pmcheck.sh --mark before-reboot
sudo reboot
sudo ./nvme-pmcheck.sh --mark after-reboot
```

The `power_cycles` difference between adjacent `nvmelog.csv` lines is the event's cost in
cycles. The expectation is 1-2 per sleep/wake cycle and 1-2 per reboot. If it turns out to
be, say, 50 for one suspend — there is the explanation for the 130 thousand, and that is
when the branch becomes interesting, because a broken suspend on this machine has already
come up in the main investigation.

Read it like this:

- **the counter does not grow at idle** → idle is not toggling it, move on to marks around
  suspend and reboot (see above);
- **it grows, and so does `runtime_suspended_time`** → the power cycle is real, the PCI-PM
  policy is to blame, cured with `power/control = on`;
- **it grows, but there was no D3** → the firmware lies, counting exits from PS3/PS4 or
  L1.2. This speeds up cell wear only slightly, nothing to panic about.

The decisive experiment for the third case is to disable APST and see whether the counter
stops:

```
nvme_core.default_ps_max_latency_us=0
```

⚠ **It will not work through `modprobe.d`** — the same pitfall #1 from
[README.md](../gpu/README.md) as with nvidia: `nvme_core` loads from the initramfs (the
root is on it), the config never reaches it. Only the kernel command line:
`LINUX_OPTIONS` in `/etc/sdboot-manage.conf`, then `sudo sdboot-manage gen`.

Rollback: remove the parameter and rebuild. The cost of disabling APST is a slightly
higher battery drain at idle, so this is diagnostics, not a cure.

## Drive state: no alarm

`SMART overall-health: PASSED`, `Critical Warning: 0x00`, spare 100% with a threshold of
10%, `media_errors` 0, no thermal throttling ever
(`Warning Comp. Temperature Time: 0`). The 16,567 error log entries are
`Invalid Field in Command`, unsupported commands from the kernel and utilities rejected
by the firmware, unrelated to data safety.

Monitoring: `sudo smartctl -a /dev/nvme0n1` every six months, watch the **trend** of
`Percentage Used`, not the number itself. Alarm thresholds: `Available Spare` below 10%,
any non-zero `media_errors`, `Critical Warning` other than 0x00.

## What's next

There are no active tasks, the branch is closed. Two optional leftovers remain:

1. `sudo smartctl -a /dev/nvme0n1` every six months — watch the **trend** of
   `Percentage Used`, not the number itself. Alarm: `Available Spare` below 10%, non-zero
   `media_errors`, `Critical Warning` other than 0x00.
2. At the next OS reinstall, reformat to a 4K sector (`nvme format -l 1`, a full wipe).
   This will reduce write amplification.

If the counter suddenly starts gaining a dozen per hour again, the tool is in place:
`./nvme-pmcheck.sh 600` and marks around events.
