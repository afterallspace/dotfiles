#!/usr/bin/env bash
# Hide apps from the GNOME grid without breaking file associations.
#
#   hide-apps.sh                        rebuild every override listed below
#   hide-apps.sh list                   status: hidden, stale or missing
#   hide-apps.sh restore <name.desktop> put one app back in the grid
#
# A file in ~/.local/share/applications REPLACES the system one outright rather
# than extending it, so an override is a full copy of the system .desktop plus
# NoDisplay=true. That keeps MimeType intact and double-click from Nautilus
# keeps working. NoDisplay, not Hidden: Hidden means "deleted by the user" and
# takes every association down with it.
#
# The downside of a copy is that it does not follow package updates — a newly
# added MimeType stays frozen at the old list. Rerunning fixes it; `list` shows
# where that is due.
set -uo pipefail

SRC=/usr/share/applications
DST="$HOME/.local/share/applications"

APPS=(
  # opened from the file manager only, pointless in the grid
  org.gnome.Loupe.desktop    # Image Viewer
  org.gnome.Decibels.desktop # Audio Player
  org.gnome.Showtime.desktop # Video Player
  org.gnome.Evince.desktop   # Document Viewer
  # service clutter pulled into the menu by dependencies
  avahi-discover.desktop     # Avahi Zeroconf Browser
  bssh.desktop               # Avahi SSH Server Browser
  bvnc.desktop               # Avahi VNC Server Browser
  lstopo.desktop             # Hardware Locality lstopo
  qv4l2.desktop              # Qt V4L2 test Utility
  qvidcap.desktop            # Qt V4L2 video capture utility
)

MODE="${1:-apply}"
mkdir -p "$DST"

# Appends NoDisplay=true to the end of the [Desktop Entry] group specifically,
# not the end of the file: Showtime continues into [Desktop Action new-window],
# and the flag has no effect if it lands there.
gen() {
  awk '/^\[Desktop Action/ && !d { print "NoDisplay=true"; print ""; d=1 }
       { print }
       END { if (!d) print "NoDisplay=true" }' "$1"
}

rule="═══════════════════════════════════════════════════════"
printf '%s\n HIDE APPS FROM THE GRID\n%s\n' "$rule" "$rule"

case "$MODE" in
restore)
  name="${2:-}"
  [[ -n $name ]] || { echo "  usage: hide-apps.sh restore org.gnome.Loupe.desktop"; exit 1; }
  # Only ever touch overrides this script owns: the same directory also holds
  # third-party ones (the mullvad-exclude wrappers) that must survive.
  [[ " ${APPS[*]} " == *" $name "* ]] || { echo "  ✗ $name is not in this script's list — leaving it alone."; exit 1; }
  [[ -f $DST/$name ]] || { echo "  $name is not hidden anyway."; exit 0; }
  grep -q '^NoDisplay=true' "$DST/$name" || { echo "  ✗ $DST/$name has no NoDisplay — not ours, leaving it alone."; exit 1; }
  rm -v "$DST/$name"
  update-desktop-database "$DST" 2>/dev/null
  echo "  Done. Drop the name from APPS, or the next run hides it again."
  ;;

list)
  for a in "${APPS[@]}"; do
    if [[ ! -f $SRC/$a ]]; then                                  status="package not installed"
    elif [[ ! -f $DST/$a ]]; then                                status="NOT HIDDEN"
    elif diff -q <(gen "$SRC/$a") "$DST/$a" >/dev/null 2>&1; then status="hidden"
    else                                                         status="hidden, but STALE (system file changed)"
    fi
    printf '  %-32s %s\n' "$a" "$status"
  done
  printf '\n  Stale entries are fixed by running with no arguments.\n%s\n' "$rule"
  ;;

apply)
  made=0 skipped=0 same=0
  for a in "${APPS[@]}"; do
    if [[ ! -f $SRC/$a ]]; then
      printf '  %-32s skipped, package not installed\n' "$a"; (( skipped++ )); continue
    fi
    if [[ -f $DST/$a ]] && diff -q <(gen "$SRC/$a") "$DST/$a" >/dev/null 2>&1; then
      (( same++ )); continue
    fi
    gen "$SRC/$a" >"$DST/$a" && printf '  %-32s hidden\n' "$a" && (( made++ ))
  done
  (( made > 0 )) && update-desktop-database "$DST" 2>/dev/null
  printf '\n  created/updated: %s, already current: %s, skipped: %s\n' "$made" "$same" "$skipped"
  (( made > 0 )) && echo "  If icons are still showing, log out and back in."
  echo "$rule"
  ;;

*)
  echo "  unknown mode: $MODE" >&2; exit 1
  ;;
esac
