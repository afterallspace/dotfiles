#!/usr/bin/env bash
# GPU + CPU + platform power budget telemetry, 1 Hz.
# Usage:  ./monitor.sh <test-name>
# Stop: Ctrl+C (or kill). Writes to ./runs/<test-name>/
set -uo pipefail

TAG="${1:-run}"
# MONITOR_DIR overrides the directory (used by loadtest.sh)
# MONITOR_NOUI=1 means do not draw the live table, just write logs
DIR="${MONITOR_DIR:-$(cd "$(dirname "$0")" && pwd)/runs/${TAG}_$(date +%Y%m%d-%H%M%S)}"
mkdir -p "$DIR"

RAPL_PKG=/sys/class/powercap/intel-rapl:0
RAPL_PSYS=/sys/class/powercap/intel-rapl:1

# find thermal zones by name: numbering does not match glob order
zone_by_name() {
  for z in /sys/class/thermal/thermal_zone*/; do
    [ "$(cat "$z/type" 2>/dev/null)" = "$1" ] && { echo "$z/temp"; return; }
  done
}
TZ_PKG=$(zone_by_name x86_pkg_temp)   # CPU package temperature
TZ_SKIN=$(zone_by_name SEN3)          # the hottest of the chassis sensors

# energy_uj is readable only by root: open it for reading once (resets after a reboot)
if [ ! -r "$RAPL_PKG/energy_uj" ]; then
  echo "sudo is needed to open the RAPL energy counters for reading (until reboot):"
  sudo chmod a+r "$RAPL_PKG/energy_uj" "$RAPL_PSYS/energy_uj" 2>/dev/null
fi
[ -r "$RAPL_PKG/energy_uj" ] || echo "WARNING: RAPL unavailable, the pkg_w/psys_w columns will be empty."

echo "Writing to: $DIR"
echo "Stop with Ctrl+C when the test is done."

# --- snapshot of static info at start ---
{
  echo "=== $(date -Is) tag=$TAG ==="
  echo "--- kernel: $(uname -r)"
  echo "--- platform_profile: $(cat /sys/firmware/acpi/platform_profile 2>/dev/null)"
  echo "--- governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)  epp: $(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null)"
  echo "--- no_turbo: $(cat /sys/devices/system/cpu/intel_pstate/no_turbo 2>/dev/null)  max_perf_pct: $(cat /sys/devices/system/cpu/intel_pstate/max_perf_pct 2>/dev/null)"
  echo "--- RAPL limits:"
  for d in /sys/class/powercap/intel-rapl:*/; do
    [ -f "$d/name" ] || continue
    n=$(cat "$d/name")
    for c in "$d"constraint_*_name; do
      [ -e "$c" ] || continue
      b=${c%_name}
      echo "    $n / $(cat "$c") = $(cat "${b}_power_limit_uw" 2>/dev/null) uW"
    done
  done
  echo "--- battery: $(cat /sys/class/power_supply/BAT0/status 2>/dev/null) $(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)% power_now=$(cat /sys/class/power_supply/BAT0/power_now 2>/dev/null) uW"
  echo "--- AC online: $(cat /sys/class/power_supply/ADP1/online 2>/dev/null)"
  echo "--- nvidia power limit: $(nvidia-smi --query-gpu=power.default_limit,power.max_limit --format=csv,noheader)"
  echo "--- pcie: gen $(cat /sys/bus/pci/devices/0000:01:00.0/current_link_speed) width x$(cat /sys/bus/pci/devices/0000:01:00.0/current_link_width)"
} > "$DIR/static.txt" 2>&1

# --- GPU stream (nvidia-smi is kept alive: minimal overhead) ---
nvidia-smi \
  --query-gpu=timestamp,power.draw.instant,clocks.sm,clocks.mem,utilization.gpu,utilization.memory,temperature.gpu,pstate,pcie.link.gen.current,pcie.link.width.current,clocks_event_reasons.active \
  --format=csv,noheader,nounits -l 1 > "$DIR/gpu.csv" 2>"$DIR/gpu.err" &
GPU_PID=$!

# --- system stream ---
(
  echo "epoch,pkg_w,psys_w,cpu_freq_avg_mhz,cpu_freq_max_mhz,pkg_temp_c,sen3_c,bat_status,bat_pct,bat_power_w,ac_online,pkg_throttle_count,core_throttle_count,platform_profile"
  pe=$(cat "$RAPL_PKG/energy_uj" 2>/dev/null || echo 0)
  se=$(cat "$RAPL_PSYS/energy_uj" 2>/dev/null || echo 0)
  pt=$(date +%s%N)
  while :; do
    sleep 1
    pe2=$(cat "$RAPL_PKG/energy_uj" 2>/dev/null || echo 0)
    se2=$(cat "$RAPL_PSYS/energy_uj" 2>/dev/null || echo 0)
    pt2=$(date +%s%N)
    dt=$(awk -v a="$pt2" -v b="$pt" 'BEGIN{printf "%.6f",(a-b)/1e9}')

    pkg_w=$(awk -v a="$pe2" -v b="$pe" -v d="$dt" 'BEGIN{e=a-b; if(e<0)e+=262143328850; if(d>0)printf "%.2f", e/1e6/d; else print ""}')
    psys_w=$(awk -v a="$se2" -v b="$se" -v d="$dt" 'BEGIN{e=a-b; if(e<0)e+=262143328850; if(d>0)printf "%.2f", e/1e6/d; else print ""}')

    read -r favg fmax < <(awk '{s+=$1; if($1>m)m=$1; n++} END{printf "%.0f %.0f", s/n/1000, m/1000}' /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq 2>/dev/null)

    ptemp=$(awk '{printf "%.1f", $1/1000}' "$TZ_PKG" 2>/dev/null)
    sen3=$(awk '{printf "%.1f", $1/1000}' "$TZ_SKIN" 2>/dev/null)

    bs=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
    bp=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
    bw=$(awk '{printf "%.2f", $1/1e6}' /sys/class/power_supply/BAT0/power_now 2>/dev/null)
    ac=$(cat /sys/class/power_supply/ADP1/online 2>/dev/null)

    pkgthr=$(cat /sys/devices/system/cpu/cpu0/thermal_throttle/package_throttle_count 2>/dev/null)
    corethr=$(cat /sys/devices/system/cpu/cpu0/thermal_throttle/core_throttle_count 2>/dev/null)
    pp=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null)

    echo "$(date +%s),$pkg_w,$psys_w,$favg,$fmax,$ptemp,$sen3,$bs,$bp,$bw,$ac,$pkgthr,$corethr,$pp"

    pe=$pe2; se=$se2; pt=$pt2
  done
) > "$DIR/sys.csv" &
SYS_PID=$!

cleanup() {
  kill "$GPU_PID" "$SYS_PID" 2>/dev/null
  wait "$GPU_PID" "$SYS_PID" 2>/dev/null
  echo
  echo "Done. Data: $DIR"
  echo "Analysis: $(dirname "$0")/summary.sh \"$DIR\""
}
trap cleanup EXIT INT TERM

if [ "${MONITOR_NOUI:-0}" = "1" ]; then
  # "just write logs" mode: wait until killed
  while :; do sleep 3600; done
fi

# live indicator in the terminal
printf "\n%-9s %7s %7s %7s %8s %7s %6s %6s\n" TIME GPU_W GPU_MHz GPU_% PKG_W PSYS_W CPUMHz BAT_W
while :; do
  sleep 2
  g=$(tail -1 "$DIR/gpu.csv" 2>/dev/null)
  s=$(tail -1 "$DIR/sys.csv" 2>/dev/null)
  [ -z "$g" ] && continue
  IFS=',' read -r _ gw gsm _ gu _ _ _ _ _ _ <<< "$g"
  IFS=',' read -r _ pw sw _ fm _ _ _ _ bw _ _ _ _ <<< "$s"
  printf "%-9s %7s %7s %7s %8s %7s %6s %6s\n" "$(date +%H:%M:%S)" "${gw// /}" "${gsm// /}" "${gu// /}" "${pw:-–}" "${sw:-–}" "${fm:-–}" "${bw:-–}"
done
