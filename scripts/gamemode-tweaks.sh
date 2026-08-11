#!/bin/bash
# Lock GPU clocks for the duration of a game.
#
# Run straight from gamemode.ini as `sudo <this path> start|stop`, permitted by
# /etc/sudoers.d/gamemode-tweaks. There is no copy under /usr/local/bin.
#
# EDITING: this file is held immutable. Without that, a sudoers rule pointing
# at a path under ~ would let anything running as afterall rewrite the script
# and gain root. Unlock, edit, lock again:
#   sudo chattr -i ~/.config/scripts/gamemode-tweaks.sh
#   sudo chattr +i ~/.config/scripts/gamemode-tweaks.sh
set -u

if [ "${1:-}" == "start" ]; then
    /usr/bin/nvidia-smi -lgc 450,1400
    /usr/bin/nvidia-smi -lmc 6001,6001
elif [ "${1:-}" == "stop" ]; then
    /usr/bin/nvidia-smi -rgc
    /usr/bin/nvidia-smi -rmc
else
    exit 1
fi
