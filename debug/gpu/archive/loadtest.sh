#!/usr/bin/env bash
# Automated load test: separates GPU load and CPU load
# to see whether the CPU takes power budget from the GPU.
#
#   ./loadtest.sh <label>       for example: ./loadtest.sh bat-full-ac
#
# Phases:
#   idle    15 s — baseline
#   gpu     60 s — GPU only
#   cpu     60 s — CPU only
#   both    60 s — GPU + CPU at once   ← this is where budget sharing shows up
#   idle    15 s — cooldown
set -uo pipefail
cd "$(dirname "$0")"

TAG="${1:-loadtest}"
DIR="$(pwd)/runs/${TAG}_$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DIR"

for b in vkmark stress-ng; do
  command -v "$b" >/dev/null || { echo "No $b. Install: sudo pacman -S --needed mangohud lib32-mangohud vkmark glmark2 stress-ng"; exit 1; }
done

echo "Run directory: $DIR"
echo "Battery now: $(cat /sys/class/power_supply/BAT0/capacity)% / $(cat /sys/class/power_supply/BAT0/status), AC=$(cat /sys/class/power_supply/ADP1/online)"
echo

# setsid: so the logger becomes the leader of its process group and can be
# killed whole along with its children (otherwise they stay behind as orphans)
setsid env MONITOR_DIR="$DIR" MONITOR_NOUI=1 ./monitor.sh "$TAG" &
MON=$!
sleep 2

: > "$DIR/phases.csv"
mark() { echo "$(date +%s),$1" >> "$DIR/phases.csv"; echo ">>> phase: $1"; }

GPU_PID=""; CPU_PID=""

# Take the dGPU's UUID straight from vkmark (vendor 0x10DE = NVIDIA), so there is no guessing
# and no dependence on device enumeration order.
NV_UUID=$(vkmark -L 2>/dev/null | awk '
  /Vendor ID:/   { vendor = $3 }
  /Device UUID:/ { if (vendor == "0x10DE") { print $3; exit } }')
if [ -z "$NV_UUID" ]; then
  echo "NVIDIA not found among Vulkan devices. Check: vkmark -L"; exit 1
fi
echo "dGPU: UUID $NV_UUID"

# -D           — pin the load to the dGPU explicitly
# --fullscreen — otherwise the window gets no frame callbacks and rendering stalls
# WITHOUT -p immediate: the card does NOT SUPPORT this mode, vkmark crashes at once
# with "Selected present mode Immediate is not supported". That leaves mailbox.
start_gpu() {
  vkmark -D "$NV_UUID" --fullscreen --run-forever -b shading \
    >>"$DIR/vkmark.log" 2>&1 &
  GPU_PID=$!
  sleep 5
  kill -0 "$GPU_PID" 2>/dev/null || {
    echo "!!! vkmark failed to start, see $DIR/vkmark.log:"
    head -5 "$DIR/vkmark.log" | sed 's/^/!!!   /'
  }
}
stop_gpu()  { [ -n "$GPU_PID" ] && kill "$GPU_PID" 2>/dev/null; GPU_PID=""; }
start_cpu() { stress-ng --cpu 12 --cpu-method matrixprod -t 0 >/dev/null 2>&1 & CPU_PID=$!; }
stop_cpu()  { [ -n "$CPU_PID" ] && { kill "$CPU_PID" 2>/dev/null; pkill -P "$CPU_PID" 2>/dev/null; }; CPU_PID=""; }

finish() {
  stop_gpu; stop_cpu
  kill -TERM -"$MON" 2>/dev/null   # the whole group: monitor.sh + both its loggers
  sleep 1
  kill -KILL -"$MON" 2>/dev/null
  echo
  echo "Done: $DIR"
  echo "Report: ./loadtest-report.sh \"$DIR\""
}
trap finish EXIT INT TERM

mark idle;  sleep 15
mark gpu;   start_gpu;  sleep 12
# a safeguard against the bug recurring: make sure the load landed on the dGPU
u=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | tr -d ' ')
if [ "${u:-0}" -lt 20 ]; then
  echo "!!! WARNING: RTX 2050 utilization is only ${u}%, the load went elsewhere."
  echo "!!! The result will be invalid. Check: prime-run vulkaninfo --summary"
else
  echo "    ok, dGPU utilization is ${u}%"
fi
sleep 48
mark cpu;   stop_gpu;   start_cpu; sleep 60
mark both;  start_gpu;  sleep 60
mark idle2; stop_gpu;   stop_cpu;  sleep 15
mark end
