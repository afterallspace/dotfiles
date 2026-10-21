#!/usr/bin/env bash
# Apply login screen (GDM greeter) settings from greeter.dconf and install the
# scalable cursor theme system-wide. Rerun after editing greeter.dconf; the
# greeter picks it up on its next start (log out or reboot).
#
#   sudo ~/.config/gdm/apply.sh
set -euo pipefail

[[ $EUID -eq 0 ]] || { echo "run with sudo" >&2; exit 1; }
SRC="$(dirname "$(readlink -f "$0")")"
CONF="$SRC/greeter.dconf"
USER_HOME="$(getent passwd "${SUDO_USER:-root}" | cut -d: -f6)"

# Since GDM moved to dynamic greeter users, its own settings live per seat.
# Print them once for the record before they get overridden.
OLD=/var/lib/gdm/seat0/config/dconf/user
if [[ -f $OLD ]]; then
    echo "== settings stored by the greeter itself"
    profile="$(mktemp)"
    echo "file-db:$OLD" >"$profile"
    DCONF_PROFILE="$profile" dconf dump / || true
    rm -f "$profile"
fi

# /etc/dconf/profile/gdm takes precedence over the one GDM ships in /usr.
install -Dm644 /dev/stdin /etc/dconf/profile/gdm <<'EOF'
user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults
EOF
install -Dm644 "$CONF" /etc/dconf/db/gdm.d/00-afterall
mkdir -p /etc/dconf/db/gdm.d/locks
awk -F= '/^\[/ { sec = substr($0, 2, length($0) - 2) } /^[a-z]/ { print "/" sec "/" $1 }' "$CONF" \
    >/etc/dconf/db/gdm.d/locks/00-afterall
dconf update
echo "== locked $(wc -l </etc/dconf/db/gdm.d/locks/00-afterall) greeter keys"

# GNOME 51 draws the pointer only from SVG themes (see scripts/bibata-scalable.py),
# and the greeter has no home dir, so it needs a system-wide copy.
theme="$(sed -n "s/^cursor-theme='\(.*\)'/\1/p" "$CONF")"
built="$USER_HOME/.local/share/icons/$theme"
if [[ -d $built/cursors_scalable ]]; then
    rm -rf "/usr/local/share/icons/$theme"
    mkdir -p /usr/local/share/icons
    cp -a "$built" /usr/local/share/icons/
    chown -R root:root "/usr/local/share/icons/$theme"
    chmod -R a+rX "/usr/local/share/icons/$theme"
    echo "== installed $theme to /usr/local/share/icons"
else
    echo "no scalable $theme in $built, run scripts/bibata-scalable.py first" >&2
fi
