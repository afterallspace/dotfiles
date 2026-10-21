#!/usr/bin/env bash
# Link the launchers that keep apps outside the Mullvad tunnel. Apps that
# rewrite their own .desktop on start (Claude, VS Code) get a wrapper in
# ~/.local/bin, which comes before /usr/bin in the shell's PATH; the rest get
# a .desktop override with mullvad-exclude in Exec.
#
#   install.sh
set -euo pipefail

SRC="$(dirname "$(readlink -f "$0")")"
link() {
    mkdir -p "$2"
    for f in "$1"/*; do ln -sfn "$f" "$2/${f##*/}"; echo "linked ${f##*/}"; done
}
link "$SRC/bin" "$HOME/.local/bin"
link "$SRC/applications" "${XDG_DATA_HOME:-$HOME/.local/share}/applications"
