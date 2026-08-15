#!/usr/bin/env bash
# Session-start GPU unlock (user unit nvpcf-unlock.service): checks whether
# boost clocks are forbidden and, if so, runs the proven unlock sequence via
# /usr/local/bin/nvpcf-boot-fix.sh (sudoers NOPASSWD).
#
# Output goes to the journal only (investigation closed 15.08.2026, file
# logging retired): journalctl --user -u nvpcf-unlock.service
#
# Verdict is based on CLOCKS, not watts: locked = SM capped at ~1327 MHz,
# free = 1600+ MHz under load. Watts depend on the power source (battery,
# hungry charger, PSYS budget) and lie; the clock signature does not.
# Up to 3 unlock attempts.
echo "=== $(date -Is) session unlock ==="
echo "battery: $(cat /sys/class/power_supply/BAT0/status 2>/dev/null) \
$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)%, \
$(awk '{printf "%.1f", $1/1000000}' /sys/class/power_supply/BAT0/power_now 2>/dev/null) W; \
AC=$(cat /sys/class/power_supply/ADP1/online 2>/dev/null)"

GL=""
load_alive() { [ -n "$GL" ] && kill -0 "$GL" 2>/dev/null; }
load_start() {
  load_alive && return 0
  prime-run glmark2 --off-screen -b shading:duration=600 >/dev/null 2>&1 &
  GL=$!
  sleep 7
}
cleanup() { [ -n "$GL" ] && kill "$GL" 2>/dev/null; }
trap cleanup EXIT

# maxclk: max SM clock over 6 samples taken while utilization > 50 %.
# Prints "0" if the load never landed on the dGPU (no verdict possible).
maxclk() {
  local m=0 c u line n=0
  for _ in 1 2 3 4 5 6; do
    line=$(timeout 5 nvidia-smi --query-gpu=clocks.sm,utilization.gpu \
           --format=csv,noheader,nounits 2>/dev/null | head -1)
    c=$(echo "$line" | cut -d, -f1 | tr -d ' ')
    u=$(echo "$line" | cut -d, -f2 | tr -d ' ')
    case "$u" in ''|*[!0-9]*) sleep 1; continue ;; esac
    [ "$u" -ge 50 ] && case "$c" in *[0-9]*) [ "$c" -gt "$m" ] && m=$c; n=$((n+1)) ;; esac
    sleep 1
  done
  [ "$n" -ge 2 ] && echo "$m" || echo 0
}

load_start
clk=$(maxclk)
echo "clock under load: $clk MHz"
if [ "$clk" -ge 1500 ]; then echo "OK: already unlocked"; exit 0; fi
if [ "$clk" -eq 0 ]; then echo "FAIL: load did not land on the dGPU - no verdict"; exit 1; fi

for attempt in 1 2 3; do
  echo "-- attempt $attempt --"
  load_start
  timeout 90 sudo -n /usr/local/bin/nvpcf-boot-fix.sh
  sleep 3
  load_start
  clk=$(maxclk)
  echo "clock after: $clk MHz"
  if [ "$clk" -ge 1500 ]; then echo "OK: unlocked (attempt $attempt)"; exit 0; fi
  [ "$attempt" -lt 3 ] && sleep 10
done

echo "FAIL: still locked after 3 attempts - run manually: cd ~/.config/debug/gpu && sudo ./nvpcf-unlock.sh --stnm 3, wait 15 s, then --stnm 1 (under GPU load)"
exit 1
