#!/usr/bin/env bash
# NVMe power: why the Power Cycles counter grows faster than the machine
# powers on. Takes SMART + PCIe/APST state, computes growth over an interval.
#
#   ./nvme-pmcheck.sh            — snapshot and verdict
#   ./nvme-pmcheck.sh 600        — watch for 600 s, measure growth
#   ./nvme-pmcheck.sh --mark sleep — a mark in the log without waiting: do before and
#                                  after suspend / reboot, the difference of
#                                  adjacent nvmelog.csv lines is the answer
#
# Needs root. Better to run `sudo ./nvme-pmcheck.sh 600` right away: with a long interval
# the sudo password cache (900 s by default) expires right in the middle of the measurement.
# The script survives that (it keeps the cache alive and checks every snapshot), but
# running as root is more reliable.
set -uo pipefail

MODE=interval
SECS=0
TAG=""
case "${1:-}" in
  --mark) MODE=mark; TAG="${2:-mark}" ;;
  "")     SECS=0 ;;
  *)      SECS="$1" ;;
esac

DEV=/dev/nvme0n1
CTRL=/sys/class/nvme/nvme0
PCI=$(basename "$(readlink -f $CTRL/device 2>/dev/null)")
CSV="$(dirname "$0")/nvmelog.csv"

r() { cat "$1" 2>/dev/null; }

# ── sudo: ask for the password once and keep the cache alive ─────────────
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
  if ! sudo -n true 2>/dev/null; then
    echo "  Root is needed to read smart-log, enter the password."
    sudo -v || { echo "  ✗ The measurement is impossible without sudo."; exit 1; }
  fi
  # Refresh the timestamp every 50 s, otherwise it expires during a long sleep.
  # The streams are closed on purpose: otherwise the background loop holds stdout open
  # and the script's output does not reach `| tee` until its sleep finishes.
  ( while true; do sleep 50; sudo -n true || exit; done ) >/dev/null 2>&1 &
  KEEPALIVE=$!
  trap 'kill "$KEEPALIVE" 2>/dev/null; wait "$KEEPALIVE" 2>/dev/null' EXIT
fi

# ── reading and parsing smart-log ───────────────────────────────────────
# nvme smart-log line format: "key : value". The key is padded with TABS, not
# spaces, so compare on the trimmed string, not with a regex.
sm() { printf '%s\n' "$SMART" | awk -F: -v k="$1" '
  { key=$1; gsub(/^[ \t]+|[ \t]+$/,"",key)
    if (key==k) { v=$2; gsub(/[ \t]/,"",v); print v; exit } }'; }
# the same, but only the number: Data Units Written has a trailing "(34.08 TB)"
smn() { sm "$1" | sed 's/(.*//; s/[^0-9].*$//'; }

# Takes a smart-log and makes sure it parsed. An empty or incomplete
# snapshot is an error, not zeros: silent zeroing has already once produced
# a false verdict "the counter is idle" (the 2026-08-03 entry in NVME.md).
grab() {
  local err rc
  err=$($SUDO nvme smart-log "$DEV" 2>&1 >/tmp/nvme-pmcheck.$$ ); rc=$?
  SMART=$(cat /tmp/nvme-pmcheck.$$ 2>/dev/null); rm -f /tmp/nvme-pmcheck.$$
  if [ "$rc" -ne 0 ] || [ -z "$SMART" ]; then
    echo "  ✗ Failed to read smart-log from $DEV (code $rc)."
    [ -n "$err" ] && echo "    $err"
    exit 1
  fi
  local probe; probe=$(smn power_cycles)
  if ! [[ "$probe" =~ ^[0-9]+$ ]]; then
    echo "  ✗ smart-log was read, but the fields do not parse: the output format changed."
    echo "    Raw output for analysis:"
    printf '%s\n' "$SMART" | sed 's/^/    | /' | head -20
    exit 1
  fi
}

grab
pc0=$(smn power_cycles); poh0=$(smn power_on_hours); us0=$(smn unsafe_shutdowns)
duw0=$(smn 'Data Units Written'); rts0=$(r $CTRL/device/power/runtime_suspended_time)

csv_init() {
  [ -f "$CSV" ] || echo "timestamp,mode,tag,secs,power_cycles,delta_pc,pc_per_hour,unsafe,poh,rts_ms,pct_used" > "$CSV"
}

echo "═══════════════════════════════════════════════════════"
echo " NVMe POWER"
echo "═══════════════════════════════════════════════════════"
printf "  model                  : %s\n" "$(r $CTRL/model | xargs)"
printf "  firmware               : %s\n" "$(r $CTRL/firmware_rev | xargs)"
echo
echo "── Counters ──────────────────────────────────────────"
printf "  power_cycles           : %s\n" "$pc0"
printf "  power_on_hours         : %s\n" "$poh0"
printf "  unsafe_shutdowns       : %s\n" "$us0"
printf "  percentage_used        : %s\n" "$(sm percentage_used)"
printf "  available_spare        : %s\n" "$(sm available_spare)"
printf "  media_errors           : %s\n" "$(sm media_errors)"
awk -v c="${pc0:-0}" -v h="${poh0:-0}" 'BEGIN{
  if (h>0) { printf "  cycles per hour on     : %.1f", c/h;
             if (c/h > 2) print "   ⚠ an order of magnitude above real power-ons";
             else print "" }}'

echo
echo "── Power management ──────────────────────────────────"
printf "  PCI device             : %s\n" "$PCI"
printf "  link state             : %s\n" "$(r /sys/bus/pci/devices/$PCI/power_state)"
printf "  runtime pm             : %s (%s)\n" \
  "$(r $CTRL/device/power/control)" "$(r $CTRL/device/power/runtime_status)"
printf "  in runtime sleep       : %s ms\n" "${rts0:-—}"
printf "  d3cold allowed         : %s\n" "$(r /sys/bus/pci/devices/$PCI/d3cold_allowed)"
printf "  ASPM L1.1 / L1.2       : %s / %s\n" \
  "$(r /sys/bus/pci/devices/$PCI/link/l1_1_aspm)" "$(r /sys/bus/pci/devices/$PCI/link/l1_2_aspm)"
printf "  APST latency threshold : %s us\n" \
  "$(r /sys/module/nvme_core/parameters/default_ps_max_latency_us)"
echo "  (0 = APST off, the drive does not enter PS3/PS4)"

# ── mark mode: a line in the log and exit ───────────────────────────────
if [ "$MODE" = mark ]; then
  csv_init
  printf '%s,mark,%s,,%s,,,%s,%s,%s,%s\n' \
    "$(date -Iseconds)" "$TAG" "$pc0" "$us0" "$poh0" "${rts0:-0}" "$(sm percentage_used)" >> "$CSV"
  echo
  echo "  Mark \"$TAG\" written to $(basename "$CSV")."
  echo "  Compare adjacent lines: the power_cycles difference between marks"
  echo "  before and after an event is that event's cost in cycles."
  echo "═══════════════════════════════════════════════════════"
  exit 0
fi

# ── interval mode ───────────────────────────────────────────────────────
if [ "$SECS" -gt 0 ] 2>/dev/null; then
  echo
  echo "── Watching for $SECS s ──────────────────────────────"
  echo "  Do not touch the machine: what matters is whether the counter grows at idle."
  t0=$(date +%s)
  sleep "$SECS"
  grab            # on failure exits with an error rather than substituting zeros
  t1=$(date +%s)
  pc1=$(smn power_cycles); us1=$(smn unsafe_shutdowns); duw1=$(smn 'Data Units Written')
  rts1=$(r $CTRL/device/power/runtime_suspended_time)
  dt=$(( t1 - t0 ))
  d=$(( pc1 - pc0 ))
  rs=$(( ${rts1:-0} - ${rts0:-0} ))

  awk -v d="$d" -v t="$dt" 'BEGIN{
    printf "  power_cycles growth    : %d over %d s", d, t;
    if (t>0 && d>0) printf "  →  %.0f per hour\n", d*3600/t; else print "" }'
  printf "  unsafe_shutdown growth : %s\n" "$(( us1 - us0 ))"
  printf "  runtime sleep growth   : %s ms\n" "$rs"
  awk -v a="$duw0" -v b="$duw1" 'BEGIN{ printf "  written in the interval: %.1f MiB\n", (b-a)*512000/1048576 }'

  echo
  echo "── Verdict ───────────────────────────────────────────"
  if [ "$d" -eq 0 ]; then
    echo "  The counter is idle: power is not being toggled at idle."
    echo "  Next, measure events rather than idle:"
    echo "    ./nvme-pmcheck.sh --mark before-suspend   (then suspend and back)"
    echo "    ./nvme-pmcheck.sh --mark after-suspend"
    echo "    ./nvme-pmcheck.sh --mark before-reboot    (then reboot)"
    echo "    ./nvme-pmcheck.sh --mark after-reboot"
  elif [ "$rs" -gt 0 ]; then
    echo "  The counter grows AND the device really enters runtime sleep:"
    echo "  the power cycle is real, the PCI-PM policy is to blame."
    echo "  Check: echo on | sudo tee /sys/bus/pci/devices/$PCI/power/control"
  else
    echo "  The counter grows, but D3 never happened (runtime_suspended_time did not"
    echo "  change). So the firmware counts as a 'power cycle' exits from"
    echo "  the non-operational APST states (PS3/PS4) or from ASPM L1.2."
    echo "  There is no real power-off, this does not speed up cell wear,"
    echo "  the counter simply lies. Test by disabling APST:"
    echo "    nvme_core.default_ps_max_latency_us=0 on the kernel command line"
    echo "    (via LINUX_OPTIONS in /etc/sdboot-manage.conf + sdboot-manage gen;"
    echo "     modprobe.d will not work, nvme_core loads from the initramfs)"
  fi

  csv_init
  awk -v ts="$(date -Iseconds)" -v t="$dt" -v pc="$pc1" -v d="$d" -v u="$us1" \
      -v poh="$(smn power_on_hours)" -v rs="${rts1:-0}" -v pu="$(sm percentage_used)" 'BEGIN{
    printf "%s,interval,,%d,%d,%d,%.1f,%s,%s,%d,%s\n", ts, t, pc, d, (t>0? d*3600/t : 0), u, poh, rs, pu }' >> "$CSV"
  echo
  echo "  Written to $(basename "$CSV")"
fi
echo "═══════════════════════════════════════════════════════"
