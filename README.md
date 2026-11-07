<img src="assets/shell.png" width="100%">

# Hyprspace | Xiaomi Book Pro 2022

Custom Wayland-based environment for **CachyOS**, optimized for high-density OLED displays and hybrid graphics.

## 💻 Hardware Specs

- **Device:** Xiaomi Book Pro 2022 (16")
- **CPU:** Intel Core i7
- **GPU:** NVIDIA RTX 2050 (Mobile)
- **Display:** 4K OLED (using Hyprland scaling)

## 🛠 Tech Stack

- **WM:** [Hyprland v0.54.3+](https://hyprland.org/)
- **Shell:** Fish 🐟
- **Terminal:** Kitty
- **AUR Helper:** Paru
- **Power Management:** Gamemode + Power-profiles-daemon

## 📁 Structure

- `.config/hypr/`: Core window manager configuration (new v0.54.3 rules).
- `.config/fish/`: Shell aliases and path exports.
- `.config/kitty/`: Terminal styling.
- `.config/scripts/`: Custom utility scripts (Gamemode tweaks, etc.).
- `pkglist.txt`: Full list of explicitly installed packages.

## 🚀 Quick Start (One-Command Install)

1. **Clone this repo into ~/.config:**
   _Note: Ensure you backup your existing .config first!_
   ```bash
   git clone -b hyprland git@github.com:afterallspace/dotfiles.git ~/.config
   ```
