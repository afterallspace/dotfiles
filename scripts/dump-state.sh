#!/usr/bin/env bash
# Refresh the tracked snapshots of machine state before a commit: explicitly
# installed packages, enabled system units and the dconf dump.
#
#   dump-state.sh
set -euo pipefail

DIR="$(dirname "$(dirname "$(readlink -f "$0")")")"
pacman -Qqen >"$DIR/pkglist.txt"
pacman -Qqem >"$DIR/pkglist-aur.txt"
systemctl list-unit-files --state=enabled --no-legend --type=service,socket,timer,path | awk '{print $1}' >"$DIR/system/enabled-units.txt"
# The file chooser only remembers each app's last folder: private, and not a setting.
dconf dump / | awk '/^\[/ { skip = /^\[org\/gnome\/portal\/filechooser\// } !skip' | cat -s >"$DIR/gnome-settings.dconf"
