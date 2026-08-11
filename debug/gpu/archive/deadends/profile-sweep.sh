#!/usr/bin/env bash
# Sweep of platform modes with measurement: which profile → which STNM → which
# watt cap. Run UNDER LOAD (glmark2 in a neighboring window) and ON THE CHARGER.
#
#   prime-run glmark2 --off-screen -b shading:duration=600 &   # window 1
#   sudo ./profile-sweep.sh                                    # window 2
set -u
PP=/sys/class/platform-profile/platform-profile-0/profile
CALL=/proc/acpi/call
[ -w "$CALL" ] || { echo "sudo modprobe acpi_call"; exit 1; }
[ "$(cat /sys/class/power_supply/ADP1/online)" = 1 ] || echo "⚠ NO CHARGER: watts will be in DC mode, verdicts skewed"

stnm() { printf '%s' '\_SB.PC00.LPCB.H_EC.STNM' > "$CALL"; tr -d '\0' < "$CALL"; }
watts() { # average GPU power over 8 seconds
  nvidia-smi --query-gpu=power.draw.instant --format=csv,noheader,nounits -l 1 2>/dev/null \
    | head -8 | awk '{s+=$1; n++} END{if(n)printf "%.1f", s/n; else printf "?"}'
}

printf "%-22s %-6s %-8s %-10s %s\n" "profile" "write" "STNM" "GPU W" "note"
for p in low-power balanced balanced-performance performance balanced; do
  err=$(echo "$p" > "$PP" 2>&1) && ok="ok" || ok="REFUSED"
  sleep 6   # let the EC fire _Q24 and the driver re-read
  printf "%-22s %-6s %-8s %-10s %s\n" "$p" "$ok" "$(stnm)" "$(watts)" "${err:-}"
done
echo
echo "Current profile: $(cat $PP)"
