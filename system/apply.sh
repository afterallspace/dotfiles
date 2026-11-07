#!/usr/bin/env bash
# Install the system config kept under etc/ (zswap instead of zram, a memory
# floor for the GNOME session, systemd-oomd, the open-file limit, the ufw
# rules, the ucsi blacklist) and remove known leftovers. Safe to rerun; reboot
# once for the swap change, the file limit and the firewall.
#
#   sudo ~/.config/system/apply.sh
set -euo pipefail

[[ $EUID -eq 0 ]] || { echo "run with sudo" >&2; exit 1; }
SRC="$(dirname "$(readlink -f "$0")")/etc"

while IFS= read -r -d '' f; do
    f="${f#"$SRC"/}"
    install -Dm644 "$SRC/$f" "/etc/$f"
    echo "installed /etc/$f"
done < <(find "$SRC" -type f -print0)

# cachyos-settings ships a RAM-sized zram0; a /dev/null link of the same name
# in /etc is the documented way to switch a vendor config off.
ln -sfn /dev/null /etc/systemd/zram-generator.conf

# The installer enabled ly, which was never installed, and an older copy of
# 10-oomd.conf was left under a second name.
rm -fv /etc/systemd/system/multi-user.target.wants/ly@tty2.service /etc/systemd/system/-.slice.d/oomd.conf

systemctl daemon-reload
echo "done; reboot to move from zram to zswap and pick up the file limit"
