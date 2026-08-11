#!/usr/bin/env bash
# Quick check: is this boot "good" or "bad"?
# ~25 seconds, no game needed, no window opens.
#
#   ./bootcheck.sh
#
# WHY glmark2 --off-screen and NOT vkmark:
#   vkmark draws in a window and hits the 60 Hz vertical sync.
#   On this machine it gives at most ~11 W in any scene, so it does NOT
#   even REACH the 16 W cap seen in games. Its verdicts are
#   meaningless (the first 10 bootlog records were garbage, see bootlog-invalid.csv).
#   glmark2 --off-screen renders off-screen without sync and hits
#   exactly 16 W, the same cap as the game. Verified Jul 21.
set -uo pipefail
cd "$(dirname "$0")"

command -v glmark2 >/dev/null || { echo "glmark2 required: sudo pacman -S glmark2"; exit 1; }
command -v prime-run >/dev/null || { echo "nvidia-prime required"; exit 1; }

# On battery the card is limited by design (DC mode), so the verdict would be meaningless.
if [ "$(cat /sys/class/power_supply/ADP1/online 2>/dev/null)" != "1" ]; then
  echo "⚠ ADAPTER NOT CONNECTED. On battery the GPU is limited by design,"
  echo "  the verdict will mean nothing. Plug in the charger and retry."
  printf "  Continue anyway? [y/N] "
  read -r a; case "$a" in y|Y) ;; *) exit 1 ;; esac
fi

LOG=$(mktemp)
cleanup() { kill "${GP:-0}" 2>/dev/null; sleep 1; pkill -9 -x glmark2 2>/dev/null; rm -f "$LOG"; }
trap cleanup EXIT INT TERM

echo "Loading the dGPU for ~25 seconds (no window opens, off-screen render)..."
prime-run glmark2 --off-screen -b shading:duration=30 >"$LOG" 2>&1 &
GP=$!

sleep 6
if ! kill -0 "$GP" 2>/dev/null; then
  echo; echo "✖ glmark2 failed to start:"; sed 's/^/    /' "$LOG" | head -12; exit 1
fi
rend=$(grep -m1 "GL_RENDERER" "$LOG" | sed 's/.*GL_RENDERER: *//')
case "$rend" in
  *NVIDIA*) : ;;
  "")       echo "  (warning: glmark2 has not named the device yet)" ;;
  *)        echo "✖ The load did NOT land on the dGPU: $rend"; exit 1 ;;
esac

sum=0; max=0; n=0; usum=0; csum=0; cmax=0
for _ in $(seq 16); do
  line=$(nvidia-smi --query-gpu=power.draw.instant,clocks.sm,utilization.gpu \
         --format=csv,noheader,nounits 2>/dev/null)
  IFS=',' read -r w c u <<< "$line"
  w=${w// /}; c=${c// /}; u=${u// /}
  case "$u" in ''|*[!0-9]*) sleep 1; continue ;; esac
  [ "$u" -lt 50 ] && { sleep 1; continue; }
  sum=$(awk -v a="$sum" -v b="$w" 'BEGIN{print a+b}')
  max=$(awk -v a="$max" -v b="$w" 'BEGIN{print (b>a)?b:a}')
  usum=$((usum + u)); csum=$((csum + c)); n=$((n+1))
  case "$c" in *[!0-9]*|'') ;; *) [ "$c" -gt "$cmax" ] && cmax=$c ;; esac
  sleep 1
done
kill "$GP" 2>/dev/null

if [ "$n" -eq 0 ]; then
  echo "✖ The dGPU did not get loaded (utilization below 50%). glmark2 log:"
  sed 's/^/    /' "$LOG" | head -12; exit 1
fi

avg=$(awk -v s="$sum" -v n="$n" 'BEGIN{printf "%.1f", s/n}')
uavg=$((usum / n)); cavg=$((csum / n))

echo
echo "═══════════════════════════════════════════════════"
printf "  GPU power    : %s W avg, %s W max   (limit 35)\n" "$avg" "$max"
printf "  SM clock     : %s MHz   Utilization: %s %%   (samples: %s)\n" "$cavg" "$uavg" "$n"
printf "  Device       : %s\n" "${rend:-?}"
# Verdict by TWO signs (Jul 22): the lock means boost clocks are forbidden, a
# ceiling of ~1327 MHz; free means 1600+. Watts depend on power (battery, a starved
# charger, PSYS) and can lie either way, clocks cannot. Watts are kept
# as a second sign for the AC case.
printf "  Max clock    : %s MHz   (locked ~1327, free 1600+)\n" "$cmax"
verdict=$(awk -v a="$avg" -v c="$cmax" 'BEGIN{print (a>24 || c>=1500)?"GOOD":"BAD"}')
if [ "$verdict" = "GOOD" ]; then
  echo "  ✔ BOOT IS GOOD — the card takes its watts, ready to play."
else
  echo "  ✖ BOOT IS BAD — the card is capped at ~16 W instead of 35."
  echo "    Cannot be cured within the session, only a reboot helps."
fi
echo "═══════════════════════════════════════════════════"

wmidrv=$(readlink -f /sys/bus/wmi/devices/46C93E13-*/driver 2>/dev/null | head -1 | xargs -r basename)
mono() { journalctl -k -b 0 --no-pager -o short-monotonic 2>/dev/null \
         | grep -m1 -F "$1" | grep -oE "^\[ *[0-9]+\.[0-9]+\]" | tr -d '[] '; }
t_nvdrm=$(mono "[nvidia-drm] [GPU ID"); t_i915=$(mono "i915 0000:00:02.0: [drm] Found")
gap="?"; [ -n "$t_nvdrm" ] && [ -n "$t_i915" ] && \
  gap=$(awk -v a="$t_i915" -v b="$t_nvdrm" 'BEGIN{printf "%+.0f", (a-b)*1000}')
rtd3=$(head -1 /proc/driver/nvidia/gpus/0000:01:00.0/power 2>/dev/null | sed 's/.*: *//')
bat="$(cat /sys/class/power_supply/BAT0/status 2>/dev/null) $(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)%"
# The charge phase is the key variable of the "charging at boot" hypothesis:
# active charging (>8 W at <95%) versus trickle/full (<7 W at >97%).
# The status string does NOT distinguish these, so charging watts are recorded separately.
batw=$(awk '{printf "%.1f", $1/1000000}' /sys/class/power_supply/BAT0/power_now 2>/dev/null)
profile=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null)

echo
echo "  State of this boot:"
printf "    battery               : %s, %s W charge/discharge\n" "$bat" "${batw:-?}"
printf "    platform_profile      : %s\n" "${profile:-?}"
printf "    RTD3                  : %s\n" "${rtd3:-?}"
printf "    nvidia→i915 gap       : %s ms\n" "$gap"
printf "    WMI 46C93E13          : %s\n" "${wmidrv:-—}"

# The investigation was closed on 2026-08-15: bootlog.csv and journal snapshots are no
# longer kept, the script stays as pure diagnostics (a check after driver/BIOS
# updates). The final statistics are in SOLUTION.md.
