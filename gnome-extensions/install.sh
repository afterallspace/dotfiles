#!/usr/bin/env bash
# Link the extensions kept in this directory into GNOME Shell and compile
# their settings schemas. Safe to rerun after every pull or schema edit.
#
#   install.sh    link all of them (a relogin picks up new ones on Wayland)
set -euo pipefail

SRC="$(dirname "$(readlink -f "$0")")"
DST="${XDG_DATA_HOME:-$HOME/.local/share}/gnome-shell/extensions"
mkdir -p "$DST"

for dir in "$SRC"/*@*/; do
    dir="${dir%/}"
    uuid="${dir##*/}"
    if [[ -e $DST/$uuid && ! -L $DST/$uuid ]]; then
        echo "skip $uuid: $DST/$uuid is a real directory, remove it first" >&2
        continue
    fi
    # The compiled schema is a build artifact and stays out of git.
    if [[ -d $dir/schemas ]]; then
        glib-compile-schemas --strict "$dir/schemas"
    fi
    ln -sfn "$dir" "$DST/$uuid"
    echo "linked $uuid"
done
