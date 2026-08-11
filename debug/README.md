# System debugging — Xiaomi Book Pro 16 2022 / CachyOS

The shared directory of investigations on this machine. One branch — one
subdirectory with its own documentation, tools and logs.

Hardware and the common trouble: Xiaomi did not ship sane ACPI tables, BIOS
`XMAAD6B0P1717` dated **2022-12-13** has never been updated. Most of the problems
here grow from that — power, UCSI, missing interfaces.

## Branches

| Directory | Topic | Status |
|---|---|---|
| [gpu/](gpu/README.md) | RTX 2050 choked to 16 W instead of 35 | **closed Aug 15**: the automation works, telemetry stopped, summary in [SOLUTION.md](gpu/SOLUTION.md). Review Oct 21: on driver 615.78 the lock is alive, do not disable the service |
| [battery/](battery/BATTERY.md) | battery wear of 42% after 2.5 years | **active**: building the trend (since Oct 21 by itself, `batlog.timer`; 57% health, no acceleration). The "charge limit" sub-question is **closed Aug 5** — the firmware cannot do it |
| [nvme/](nvme/NVME.md) | Power Cycles counter at 130k with 6k hours | **closed Aug 3**, the counter is fine, the drive is healthy |

## Where to start

- **The GPU is choked, 17 FPS in a game** → [gpu/OPERATIONS.md](gpu/OPERATIONS.md),
  the day-to-day runbook is there.
- **You want to know what has already been tried** → the `INVESTIGATION.md` of
  the relevant branch. Read it before proposing a new hypothesis.
- **You need reference numbers for the hardware** → [gpu/DATA.md](gpu/DATA.md).

## Conventions

They exist not out of love for order, but because every violation here has
already cost hours.

1. **All history stays.** A negative result and a closed hypothesis are material
   just like a successful one. `.md` files are not cleaned up.
2. **An active branch keeps its own log** in CSV (`battery/batlog.csv`,
   `nvme/nvmelog.csv`). One tool run — one line. The trend matters more than a
   single measurement. When a branch is closed, its log is folded into final
   statistics in the `.md` and deleted (that is how gpu was closed on Aug 15).
3. **A measurement must distinguish "zero" from "could not read".** Silently
   substituting a zero has already produced a false conclusion here once
   (see the measurement journal in [nvme/NVME.md](nvme/NVME.md)).
4. **Findings are either reliable or weak.** Reliable ones are obtained within a
   single session by a before/after comparison. Weak ones required a reboot: a
   good boot comes up in about 8% of cases, so a single check proves nothing.
   Mark this right in the text.
5. **Dead ends are kept in `archive/`** with an explanation of why they are dead
   ends.

## Pitfalls of this machine

The full list is in [gpu/README.md](gpu/README.md), here are only the ones that
bite outside the GPU branch:

- **`modprobe.d` does not work** for modules from the initramfs (nvidia,
  nvme_core). Set parameters only through the kernel command line:
  `LINUX_OPTIONS` in `/etc/sdboot-manage.conf`, then `sudo sdboot-manage gen`.
- **`dmesg` is restricted** (`dmesg_restrict=1`) — use `journalctl -k`.
- **The journal gets purged within hours** unless the limits are raised (recipe
  in `gpu/README.md`).
- **`sudo` expires after 900 s** — long measurements must keep the cache warm
  themselves, otherwise half the data is silently lost.

## Layout

```
README.md      this file — the map of branches and shared conventions
CLAUDE.md      context for agents
gpu/           RTX 2050: NVPCF/SBIOS, clock lock, unlock automation
battery/       wear and the power path
nvme/          drive power and health
```
