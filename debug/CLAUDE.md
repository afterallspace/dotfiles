# Context for agents

The directory of investigations on the Xiaomi Book Pro 16 2022 laptop running
CachyOS. Read [README.md](README.md) — it has the map of branches and the
conventions. Here is only what you need to know before your first action.

## Hardware and the root of most troubles

Xiaomi did not ship correct ACPI tables. BIOS `XMAAD6B0P1717` dated 2022-12-13,
never updated. How it shows: the SBIOS returns garbage to
`PlatformRequestHandler` (chokes the GPU), `ucsi_acpi` spews
`bogus connector number`, the firmware does not report the battery's
`cycle_count`, there is no charge limit interface. Before treating the next
oddity as a kernel or driver bug, check whether it is ACPI again.

Configuration: RTX 2050 + Intel Alder Lake-P, hybrid graphics, btrfs with
`compress=zstd:1` on an NVMe Kingston FURY Renegade 2 TB, GNOME on Wayland, fish
shell, kernel `linux-cachyos`.

## How work is done here

1. **Read the relevant branch's `INVESTIGATION.md` first.** It lists every tested
   hypothesis and how it ended. Proposing an already closed hypothesis wastes
   both your time and everyone else's.
2. **Tell a reliable finding from a weak one.** A reliable one comes from a
   before/after comparison under identical conditions within a single session. A
   weak one required a reboot — and a good boot comes up in about 8% of cases, so
   4 lucky attempts in a row prove nothing. Mark this in the text.
3. **Do not delete anything from `.md` files.** Closed hypotheses and negative
   results are material, not garbage.
4. **Tools are written in bash**, in the style of `gpu/powercheck.sh`: framed
   headers, comments and output in English, an `r()` helper for reading sysfs, a
   snapshot mode and a watch mode, a line written to the branch's CSV.
5. **A measurement must fail rather than substitute a zero.** If a snapshot cannot
   be read — an error and exit, with nothing written to the log. This rule was
   written in blood: a silent zero once gave a confident false verdict.
6. **Test a parser on real output, not on output pasted from the clipboard.**
   `nvme-cli` pads keys with tabs; a fixture that went through the clipboard
   contains spaces, and the test goes green on false data.

## Pitfalls that cost hours

- `modprobe.d` **does not work** for modules loaded from the initramfs (`nvidia`,
  `nvme_core`). Only the kernel command line: `LINUX_OPTIONS` in
  `/etc/sdboot-manage.conf`, then `sudo sdboot-manage gen`.
- `/sys/module/nvidia/parameters/` is empty — check that parameters applied
  through `/proc/driver/nvidia/params`.
- `dmesg` is restricted (`dmesg_restrict=1`), use `journalctl -k`.
- `vkmark` is no good for loading the GPU — it hits the 60 Hz vsync. Only
  `prime-run glmark2 --off-screen`.
- `nvidia-smi -pl` is locked in the vBIOS.
- Do not minimize the game before `nvidia-smi` — the GPU drops to P5, the snapshot
  lies.
- **`nvidia-smi` wakes the card from D3cold** — it cannot measure idle, it will
  show wake-up power in `P0`. Only sysfs: `power_state`,
  `power/runtime_status`, the growth of `power/runtime_suspended_time`.
- `sudo` expires after 900 s: long measurements must keep the cache warm.
- `du`/`ncdu` show the logical size — on btrfs with compression the real usage is
  lower, count with `compsize`.
- **A recursive `grep -r` over `/sys` hangs the machine.** Virtual files read
  slowly and endlessly; on Aug 3 such a search held all 16 threads at 100% for
  fifteen minutes. In sysfs search only with `find` by name, with `-maxdepth` and
  under `timeout`, without reading contents.

## Boundaries

- Do not trigger reboots or touch the bootloader without an explicit request.
- Do not edit `/usr/local/bin/nvpcf-boot-fix.sh` and `/etc/sudoers.d/*` without
  an explicit request — the GPU unlock automation and the sudo rules depend on
  them.
- `gpu/archive/` holds knowingly invalid data and dead-end tools. Conclusions from
  there are not valid, but they should not be deleted either.
