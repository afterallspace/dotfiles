#!/usr/bin/env bash
# gamemoderun for games that crash when pinned to the P-cores.
#
# gamemode 1.8 pins every client to the fastest cores (0-7 on this i7-1260P,
# pin_cores is on by default for hybrid CPUs) and children inherit the mask.
# ELDEN RING's Wwise then fails to start its audio thread and the game panics
# (MoWwiseMan.cpp(883)). Here this shell is the client and takes the pinning,
# while the game runs as its child on every online core. gamemoded ends the
# session once this shell exits.
#
#   Steam launch options: prime-run ~/.config/scripts/gamemode-nopin.sh %command%

gamemoded -r$$ >/dev/null || echo "gamemode-nopin: gamemode request failed" >&2
taskset -c "$(</sys/devices/system/cpu/online)" "$@"
