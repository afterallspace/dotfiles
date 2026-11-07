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

- **DE:** GNOME Shell 51 on Wayland
- **Shell:** Fish 🐟 + [Starship](https://starship.rs/)
- **Terminal:** [Ghostty](https://ghostty.org/)
- **AUR Helper:** Paru
- **Power Management:** Gamemode + custom GPU clock locking
- **VPN:** Mullvad (with split tunneling for Steam, Spotify, VS Code and Claude)

## 📁 Structure

- `fish/` — shell config, `fnm`/`pnpm` paths, `fastfetch` greeting.
- `ghostty/`, `fontconfig/` — terminal and UI styling.
- `fastfetch/` — fetch config and the banner image above.
- `gnome-extensions/` — own Shell extensions plus maintained forks of
  third-party ones, see [`gnome-extensions/README.md`](gnome-extensions/README.md).
- `gdm/` — login screen settings (`greeter.dconf`), applied with
  `sudo gdm/apply.sh`; GDM ignores the user's own dconf.
- `scripts/` — utility scripts. `gamemode-tweaks.sh` locks GPU clocks during
  games; it is `chattr +i` locked because sudoers points at it directly.
- `systemd/user/` — **`nvpcf-unlock.service`**, the boot-time workaround that
  keeps the GPU from being throttled. Without it the machine loses ~70% of
  its GPU performance. Also a memory floor for the GNOME session, so the
  compositor is the last thing to be paged out, and `batlog.timer`, a daily
  battery wear snapshot for `debug/battery/`.
- `system/` — config that lives in `/etc` (zswap in place of zram, the
  session memory floor's system half, systemd-oomd, the open-file limit, the
  ufw firewall rules, a module blacklist), installed with
  `sudo system/apply.sh`, plus `enabled-units.txt`, the system services to
  enable.
- `split-tunnel/` — launchers that keep selected apps outside the Mullvad
  tunnel, linked into `~/.local` by `split-tunnel/install.sh`.
- `git/` — global git config and ignore list.
- `backgrounds/` — the wallpaper `gnome-settings.dconf` points at.
- `monitors.xml`, `user-dirs.dirs`, `xdg-terminals.list` —
  session bits that are tedious to recreate by hand.
- `gnome-settings.dconf` — full dconf dump. This is where the actual GNOME
  look and behaviour lives; the dotfiles alone won't restore it.
- `pkglist.txt` / `pkglist-aur.txt` — explicitly installed packages
  (`pacman -Qqen` / `pacman -Qqem`).
- **`debug/`** — see below.

## 🔬 debug/ — hardware investigations

Xiaomi shipped broken ACPI tables and never updated the BIOS
(`XMAAD6B0P1717`, dated 2022-12-13). Several subsystems misbehave as a
result, and each one has its own investigation folder with documentation,
tooling and logs. Start at [`debug/README.md`](debug/README.md).

| Branch | Problem | Status |
|---|---|---|
| [`debug/gpu/`](debug/gpu/README.md) | RTX 2050 throttled to 16 W instead of 35 W | **solved** via a runtime SSDT workaround |
| [`debug/battery/`](debug/battery/BATTERY.md) | ~43% wear (57% health) after ~2.5 years, no charge limit available | **open**, logged daily |
| [`debug/nvme/`](debug/nvme/NVME.md) | 130k power cycles reported at 6k power-on hours | **closed** — counter is fine |

Each branch keeps its own CSV log and a `*check.sh` tool. Negative results
and dead ends are kept on purpose — see the conventions in
[`debug/README.md`](debug/README.md).

## 🌿 Branches

- `main` — the setup running on this machine (GNOME).
- [`hyprland`](https://github.com/afterallspace/dotfiles/tree/hyprland) — the
  previous Hyprland setup, with its own history and README.

`~/.config` is this repo's working tree, so switching branches there replaces
the live config. To read the other branch, use `git show hyprland:<path>`.

## 🚀 Quick Start

1. **Clone into `~/.config`:**
   _Back up your existing `.config` first._
   ```bash
   git clone git@github.com:afterallspace/dotfiles.git ~/.config
   ```

2. **Restore packages:**
   ```bash
   sudo pacman -S --needed - < ~/.config/pkglist.txt
   paru -S --needed - < ~/.config/pkglist-aur.txt
   ```

3. **Restore GNOME settings:**
   ```bash
   dconf load / < ~/.config/gnome-settings.dconf
   ```

   Then link the Shell extensions and split-tunnel launchers, restore the
   wallpaper, build the SVG cursor theme GNOME 51 needs, hide the listed
   launchers from the app grid, apply the login screen and system settings,
   enable the system services and reboot:
   ```bash
   ~/.config/gnome-extensions/install.sh
   ~/.config/split-tunnel/install.sh
   install -Dm644 -t ~/.local/share/backgrounds ~/.config/backgrounds/*
   ~/.config/scripts/bibata-scalable.py
   ~/.config/scripts/hide-apps.sh
   sudo ~/.config/gdm/apply.sh
   sudo ~/.config/system/apply.sh
   sudo systemctl enable $(cat ~/.config/system/enabled-units.txt)
   ```

4. **Re-arm the GPU workaround** — the service alone is not enough, it needs
   a root helper and a sudoers rule. Full procedure in
   [`debug/gpu/OPERATIONS.md`](debug/gpu/OPERATIONS.md):
   ```bash
   systemctl --user enable --now nvpcf-unlock.service
   ```

5. **Re-arm the game-mode GPU lock** — `gamemode.ini` runs
   `scripts/gamemode-tweaks.sh` through sudo, so it needs a sudoers rule, and
   the script has to stay immutable for that rule to be safe:
   ```bash
   echo 'afterall ALL=(root) NOPASSWD: /home/afterall/.config/scripts/gamemode-tweaks.sh start, /home/afterall/.config/scripts/gamemode-tweaks.sh stop' | sudo tee /etc/sudoers.d/gamemode-tweaks
   sudo chmod 440 /etc/sudoers.d/gamemode-tweaks
   sudo chattr +i ~/.config/scripts/gamemode-tweaks.sh
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
