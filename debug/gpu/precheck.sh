#!/usr/bin/env bash
# Pre-game check: is the system ready, or does memory need freeing first.
#   ./precheck.sh
set -uo pipefail

ok=0; warn=0

say() { printf "  %-38s %s\n" "$1" "$2"; }

echo "═══════════════════════════════════════════════════════"
echo " GAME READINESS"
echo "═══════════════════════════════════════════════════════"

# --- swap: the main indicator ---
sw_kb=$(awk '/^SwapTotal/{t=$2} /^SwapFree/{f=$2} END{print t-f}' /proc/meminfo)
sw_mb=$((sw_kb / 1024))
if [ "$sw_mb" -lt 200 ]; then
  say "swap used" "${sw_mb} MB  ✔"
  ok=$((ok+1))
else
  say "swap used" "${sw_mb} MB  ✖ MAIN PROBLEM"
  warn=$((warn+1))
fi

# --- available memory ---
av_mb=$(( $(awk '/^MemAvailable/{print $2}' /proc/meminfo) / 1024 ))
if [ "$av_mb" -gt 7000 ]; then
  say "memory available" "${av_mb} MB  ✔"
  ok=$((ok+1))
else
  say "memory available" "${av_mb} MB  ✖ low"
  warn=$((warn+1))
fi

# --- VRAM: informational. A measurement on Jul 21 showed that with 968 MB held by
# steamwebhelper the game still ran normally, so this is not a threshold,
# just "what is in there right now".
vram_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null)
say "video memory used" "${vram_used} MB of 4096"

# --- who holds VRAM ---
echo
echo "  Holding video memory:"
# fields after stripping '|':  GPU GI CI PID TYPE NAME MEMORY
# name = second to last field, memory = last
nvidia-smi 2>/dev/null | awk '/Processes:/,0' | grep -E "MiB" | grep -v "GPU Memory" | \
  sed 's/|//g' | awk '{gsub(/MiB/,"",$NF); printf "      %-44s %6s MB\n", $(NF-1), $NF}' | head -8

# --- Steam web view GPU acceleration: informational, NOT a warning ---
# A measurement on Jul 21 confirmed: with acceleration on, the game easily takes
# its 35 W and 99% utilization. Video memory was not a bottleneck.
echo
if grep -q '"GPUAccelWebViewsV3"[[:space:]]*"1"' ~/.steam/registry.vdf 2>/dev/null; then
  say "Steam: web view GPU acceleration" "enabled (this is normal)"
fi

# --- top consumers ---
echo
echo "  Using the most memory right now:"
ps -eo rss,comm --no-headers --sort=-rss | head -6 | \
  awk '{printf "      %-42s %.0f MB\n", $2, $1/1024}'

echo
echo "═══════════════════════════════════════════════════════"
if [ "$warn" -eq 0 ]; then
  echo " ✔ All clear, ready to launch."
else
  echo " ✖ Warnings: $warn. Free some memory before playing."
  [ "$sw_mb" -ge 200 ] && echo "   Swap is not empty: close the browser and messengers, it will collapse by itself."
fi
echo "═══════════════════════════════════════════════════════"
