<img src="fastfetch/shell.png" width="100%">

# Gnomespace | Xiaomi Book Pro 16 2022

GNOME/Wayland environment for **CachyOS** on a hybrid-graphics laptop with a
4K OLED panel — plus a full hardware investigation log for a machine whose
vendor firmware fights back.

---

## 🔍 Did you land here searching for one of these?

If your NVIDIA laptop GPU is stuck around **16 W instead of its rated
35 W**, games run at ~17 FPS with heavy input lag, `nvidia-smi` reports
`SW Power Cap` throttling, and your kernel log looks like this:

```
NVRM: GPU0 ... PlatformRequestHandler failed to get target temp from SBIOS
NVRM: GPU0 ... PlatformRequestHandler failed to get platform power mode from SBIOS
      [NV_ERR_INVALID_DATA] (0x00000025)
nvidia-powerd: DC power limits table is not supported
nvidia-powerd: Client (presumably SBIOS) has requested to disable Dynamic Boost DC controller
ucsi_acpi USBC000:00: bogus connector number in CCI: 2
```

…then you have the same problem this repo documents, and there is a working
workaround: **[`debug/gpu/`](debug/gpu/README.md)** — start with
[`OPERATIONS.md`](debug/gpu/OPERATIONS.md) for the runbook, or
[`SOLUTION.md`](debug/gpu/SOLUTION.md) for the mechanism.

Short version: the platform↔GPU power negotiation channel is broken because
the SBIOS returns garbage, so the driver silently caps itself. The fix
injects a runtime SSDT exposing an `\NVST` method and drives the NVPCF
handshake manually (`NVST 3` → wait → `NVST 1`) under GPU load, re-armed on
every login by a systemd user unit. Affected hardware here is a **Xiaomi
Book Pro 16 2022** with an **RTX 2050**, BIOS `XMAAD6B0P1717` (2022-12-13),
but the mechanism should apply to any laptop whose SBIOS breaks NVPCF.

The same broken ACPI also costs this machine its battery charge-limit
interface — see [`debug/battery/`](debug/battery/BATTERY.md).

---

## 💻 Hardware Specs

- **Device:** Xiaomi Book Pro 16 2022
- **CPU:** Intel Core i7-1260P (12th Gen, Alder Lake-P)
- **GPU:** NVIDIA RTX 2050 Mobile + Intel Iris Xe (hybrid, `nvidia-prime`)
- **Display:** 4K OLED
- **Storage:** Kingston FURY Renegade 2 TB, btrfs + zstd
- **Kernel:** `linux-cachyos` 7.1 (with `linux-cachyos-lts` as fallback)

## 🛠 Tech Stack

- **DE:** GNOME Shell 50.3 on Wayland
- **Shell:** Fish 🐟 + [Starship](https://starship.rs/)
- **Terminal:** [Ghostty](https://ghostty.org/)
- **AUR Helper:** Paru
- **Power Management:** Gamemode + custom GPU clock locking
- **VPN:** Mullvad (with split tunneling for Steam and Spotify)

## 📁 Structure

- `fish/` — shell config, `fnm`/`pnpm` paths, `fastfetch` greeting.
- `ghostty/`, `fontconfig/` — terminal and UI styling.
- `fastfetch/` — fetch config and the banner image above.
- `scripts/` — utility scripts. `gamemode-tweaks.sh` locks GPU clocks during
  games; it is `chattr +i` locked because sudoers points at it directly.
- `systemd/user/` — **`nvpcf-unlock.service`**, the boot-time workaround that
  keeps the GPU from being throttled. Without it the machine loses ~70% of
  its GPU performance.
- `autostart/`, `monitors.xml`, `user-dirs.dirs`, `xdg-terminals.list` —
  session bits that are tedious to recreate by hand.
- `gnome-settings.dconf` — full dconf dump. This is where the actual GNOME
  look and behaviour lives; the dotfiles alone won't restore it.
- `pkglist.txt` / `pkglist-aur.txt` — explicitly installed packages.
- **`debug/`** — see below.

## 🔬 debug/ — hardware investigations

Xiaomi shipped broken ACPI tables and never updated the BIOS
(`XMAAD6B0P1717`, dated 2022-12-13). Several subsystems misbehave as a
result, and each one has its own investigation folder with documentation,
tooling and logs. Start at [`debug/README.md`](debug/README.md).

| Branch | Problem | Status |
|---|---|---|
| [`debug/gpu/`](debug/gpu/README.md) | RTX 2050 throttled to 16 W instead of 35 W | **solved** via a runtime SSDT workaround |
| [`debug/battery/`](debug/battery/BATTERY.md) | 39% wear after ~2.5 years, no charge limit available | **open** |
| [`debug/nvme/`](debug/nvme/NVME.md) | 130k power cycles reported at 6k power-on hours | **closed** — counter is fine |

Each branch keeps its own CSV log and a `*check.sh` tool. Negative results
and dead ends are kept on purpose — see the conventions in
[`debug/README.md`](debug/README.md).

## 🚀 Quick Start

1. **Clone into `~/.config`:**
   _Back up your existing `.config` first._
   ```bash
   git clone git@github.com:afterallspace/gnome.git ~/.config
   ```

2. **Restore packages:**
   ```bash
   sudo pacman -S --needed - < <(cut -d' ' -f1 ~/.config/pkglist.txt)
   ```
   AUR packages are listed separately in `pkglist-aur.txt` and need `paru`.

3. **Restore GNOME settings:**
   ```bash
   dconf load / < ~/.config/gnome-settings.dconf
   ```

4. **Re-arm the GPU workaround** — the service alone is not enough, it needs
   a root helper and a sudoers rule. Full procedure in
   [`debug/gpu/OPERATIONS.md`](debug/gpu/OPERATIONS.md):
   ```bash
   systemctl --user enable --now nvpcf-unlock.service
   ```

## ⚠ Machine-specific gotchas

Every one of these cost hours. Full list in
[`debug/CLAUDE.md`](debug/CLAUDE.md).

- `modprobe.d` does **not** work for modules loaded from initramfs
  (`nvidia`, `nvme_core`) — use the kernel command line via `LINUX_OPTIONS`
  in `/etc/sdboot-manage.conf`, then `sudo sdboot-manage gen`.
- `dmesg` is restricted (`dmesg_restrict=1`) — use `journalctl -k`.
- `nvidia-smi -pl` is blocked in the vBIOS.
- Recursive `grep -r` over `/sys` will peg every core for a very long time.
