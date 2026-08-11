#!/usr/bin/env bash
# Manual GPU boost unlock / EC experimentation tool. Full story: SOLUTION.md.
#
#   sudo ./nvpcf-unlock.sh          -> PROVEN RECIPE: \NVST 3, ~20 s pause,
#                                      \NVST 1 (STNM write + _Q24 each time).
#                                      Same as the automated nvpcf-boot-fix.sh.
#   sudo ./nvpcf-unlock.sh --stnm N -> single STNM write + _Q24 (N = 1/2/3).
#                                      WARNING: _Q24 while EC reports STNM=2
#                                      LOCKS the card (boost controller on).
#   sudo ./nvpcf-unlock.sh --q24    -> bare _Q24 (only safe when STNM is 3)
#
# Run under GPU load and judge by CLOCKS in nvidia-smi (locked ~1327 MHz,
# free 1600+), not by watts.
set -u
cd "$(dirname "$0")"
CALL=/proc/acpi/call
CFG=/sys/kernel/config/acpi/table

[ "$(id -u)" = 0 ] || { echo "root required: sudo $0 $*"; exit 1; }
modprobe acpi_call 2>/dev/null
modprobe acpi_configfs 2>/dev/null
[ -w "$CALL" ] || { echo "no $CALL - acpi_call module missing"; exit 1; }

measure() { # 6-second average GPU power (meaningful only under load)
  nvidia-smi --query-gpu=power.draw.instant,utilization.gpu \
    --format=csv,noheader,nounits 2>/dev/null | head -1 \
    | awk -F, '{printf "%.1f W at %d%% load", $1, $2}'
}
invoke() { printf '%s' "$1" > "$CALL"; tr -d '\0' < "$CALL"; }
loadtbl() { # loadtbl <configfs-dir-name> <aml-file>
  [ -d "$CFG/$1" ] && return 0
  mkdir -p "$CFG/$1" 2>/dev/null
  cat "$2" > "$CFG/$1/aml" 2>/dev/null || { echo "failed to load SSDT $2"; exit 1; }
  echo "SSDT $2 loaded (evaporates on reboot)"
}

stnm_now() { invoke '\_SB.PC00.LPCB.H_EC.STNM'; }

mode="${1:---auto}"
echo "before: $(measure)"

case "$mode" in
  --auto)
    loadtbl nvpcfstnm acpi/nvpcf-stnm.aml
    echo "step 1: NVST 3 -> $(invoke '\NVST 3')"
    sleep 20
    echo "step 2: NVST 1 -> $(invoke '\NVST 1')"
    ;;
  --q24)
    echo "_Q24 -> $(invoke '\_SB.PC00.LPCB.H_EC._Q24')"
    ;;
  --stnm)
    n="${2:?usage: --stnm 1|2|3}"
    loadtbl nvpcfstnm acpi/nvpcf-stnm.aml
    echo "NVST $n -> STNM=$(invoke "\\NVST $n")"
    ;;
  *) echo "usage: $0 [--stnm N|--q24]"; exit 1 ;;
esac

sleep 4
echo "after:  $(measure)"
echo "STNM now: $(stnm_now)"
echo
echo "State details: sudo ./nvpcf-peek.sh   |   full verdict: ./bootcheck.sh"
