# FPS drop — Xiaomi Book Pro 16 2022 / RTX 2050 / CachyOS

Working directory of the investigation. Started 2026-07-19, **root cause found
Jul 21**.

- **[OPERATIONS.md](OPERATIONS.md)** — ⭐ OPERATIONS: how the automation works,
  what to do when locked, reinstalling the service. Start here.
- **[BUGREPORT.md](BUGREPORT.md)** — ready-to-file bug report text for NVIDIA.
- **[SOLUTION.md](SOLUTION.md)** — the mechanism and the history of the fix.
- **[INVESTIGATION.md](INVESTIGATION.md)** — the whole path: every hypothesis,
  how it was tested, how it ended. Read it before proposing a new one.
- **[DATA.md](DATA.md)** — all measurements, reference numbers, hardware
  configuration.
- This file — status, tools, workflow.

Sibling investigation branches are in [../README.md](../README.md).

---

## Symptom

INSIDE, 4K, Steam + Proton. FPS drops from 55-60 to 17 and stays at that
minimum, plus heavy input lag. The drop comes 2-3 seconds after the game
starts. Reinstalling the OS helps for exactly one evening. The same thing
happened on CachyOS + Hyprland (there the degradation took ~2 months).

## What is firmly established

**The GPU is choked to ~16 W instead of the rated 35** at full load.
This is not heat (53 °C with the threshold at 97), not a power shortage (PSYS
43 W with a limit of 56, CPU 14 W with a limit of 52), not memory, not the bus,
not the compositor. The throttle flag is always `0x4 SwPowerCap` — a
**software** cap that the driver set for itself. There were never any hardware
cuts (`0x8`, `0x100`).

Meanwhile `enforced.power.limit` reports 35.00 W. The real cap is not visible
in any accessible field — it lives in the GSP firmware.

**The state is latched at boot** and nothing changes it within a session: not
the battery, not stopping daemons, not RTD3, not PowerMizer. Only a reboot
helps — and only about 8% of the time.

**The root is in the firmware.** On every boot:

```
NVRM: GPU0 ... PlatformRequestHandler failed to get target temp from SBIOS
NVRM: GPU0 ... PlatformRequestHandler failed to get platform power mode from SBIOS
      [NV_ERR_INVALID_DATA] (0x00000025)
nvidia-powerd: DC power limits table is not supported
nvidia-powerd: Client (presumably SBIOS) has requested to disable Dynamic Boost DC controller
```

The "platform ↔ GPU" negotiation channel does not work. But the same errors
were present in the good session too, so they are a necessary condition, not
the trigger. What pulls the trigger has not been found.

## The main problem of the investigation

**A good boot comes up in about 8% of cases** (2 of ~15). With a base rate like
that, a single check proves nothing: the probability of seeing a good boot
within 4 attempts, even with a useless intervention, is about 28%.

So findings come in two grades:

- **Reliable** — obtained *within a single session*, by a before/after
  comparison under identical conditions: stopping `nvidia-powerd`, changing the
  battery state on the fly, RTD3, PowerMizer, memory, CPU limits.
- **Weak** — required a reboot and were judged on 1-4 boots: the WMI driver,
  DRM order, `kms`, charging at boot time. Formally "did not help",
  statistically "could not be told apart from bad luck".

Telling 8% from 50% takes 25-35 boots per intervention.

---

## Tools

| Script | Purpose |
|---|---|
| `./bootcheck.sh` | **the main one**. Whether this boot is good or bad, ~25 s. Since Aug 15 it records nothing — pure diagnostics |
| `./powercheck.sh [sec]` | the power path: PD contract, battery wear. With the adapter plugged in |
| `./precheck.sh` | memory and VRAM before a game |
| `archive/monitor.sh` etc. | tools of the closed monitoring (telemetry, boot diff) |

Dependencies: `sudo pacman -S --needed mangohud lib32-mangohud glmark2`

### How to use

```fish
# after a driver/BIOS update — a verdict in 25 seconds
cd ~/.config/debug/gpu && ./bootcheck.sh
```

Threshold: **~16 W is bad, 30+ is good.** There is a wide gap between them.

---

## ⚠ Pitfalls of this machine

Each one cost hours. Verified, do not repeat:

1. **`modprobe.d` does NOT work for nvidia.** The module loads from the
   initramfs (the `kms` hook), the config never reaches it. Set parameters only
   through the kernel command line: `LINUX_OPTIONS` in
   `/etc/sdboot-manage.conf`, then `sudo sdboot-manage gen`.
2. **`/sys/module/nvidia/parameters/` is empty.** Check that parameters were
   applied only through `/proc/driver/nvidia/params`.
3. **`vkmark` is no good for measuring.** It draws in a window, hits the 60 Hz
   vertical sync and gives at most ~11 W in any scene — it does not even reach
   the 16 W cap. Use `prime-run glmark2 --off-screen`.
4. **The card does not support `-p immediate` in vkmark** — it crashes
   instantly.
5. **`nvidia-smi -pl` is locked in the vBIOS** — `not supported in current scope`.
5a. **`nvidia-smi` WAKES the card from D3cold — it cannot measure idle.** With
   RTD3 enabled the card is powered off, the driver has to bring it up for the
   query, and it comes out in `P0`. The resulting ~10 W is wake-up power, not
   idle power; with RTD3 disabled the same command honestly showed 5 W in
   `P8`, because there was nothing to wake. A relative of pitfall #8: the
   measurement destroys what it measures. Check idle **only through sysfs**,
   which does not touch the card:
   ```fish
   cat /sys/bus/pci/devices/0000:01:00.0/power_state          # D3cold / D0
   cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status # suspended / active
   cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_suspended_time
   ```
   The share of sleep is computed from the growth of `runtime_suspended_time`
   over an interval. A clean measurement on Aug 3 gave 60006 ms of sleep over
   60004 ms of real time — 100%.
6. **`dmesg` is restricted** (`dmesg_restrict=1`), use `journalctl -k`.
7. **The journal gets purged within hours.** The log of the good 12:57 boot was
   lost three hours later. Raise the limits:
   ```fish
   sudo mkdir -p /etc/systemd/journald.conf.d
   printf '[Journal]\nSystemMaxUse=2G\nMaxRetentionSec=1month\n' | \
     sudo tee /etc/systemd/journald.conf.d/keep-more.conf
   sudo systemctl restart systemd-journald
   ```
8. **Do not minimize the game before `nvidia-smi`** — it pauses, the GPU drops
   to P5, and you end up stitching together incompatible snapshots. Once this
   sent the investigation off track for half a day.

---

## What remains untested

1. **The 580 driver branch** — the last one with Ampere support, available in
   the repos (`nvidia-580xx-open-dkms`, `nvidia-580xx-dkms`). The proprietary
   variant can run without GSP (`NVreg_EnableGpuFirmware=0`), the open one
   cannot. Makes sense only with statistics over many boots.
2. **A BIOS update from Xiaomi** — the root is the SBIOS returning garbage.
3. **A bug report to NVIDIA.** There is enough material: paired measurements,
   the reference, `bootlog.csv`, snapshots, the table of closed hypotheses.
4. **Automated boot cycling** — a systemd service that runs `bootcheck.sh` on
   every startup and keeps rebooting until the first good boot. The only way to
   get statistics of a size that is unrealistic by hand. Not implemented,
   requires the owner's decision — it means reboots in a loop.

---

## Directory layout

```
README.md            this file — status and tools
INVESTIGATION.md     the whole path and all hypotheses
DATA.md              all measurements and configuration
bootcheck.sh …       working scripts
archive/             invalid, outdated and closed monitoring — see archive/README.md

Telemetry (bootlog.csv, runs/, snapshots/, unlock.log) was deleted on Aug 15 when
the branch was closed; the final numbers are in SOLUTION.md.
```
