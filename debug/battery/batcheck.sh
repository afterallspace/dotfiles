#!/usr/bin/env bash
# Battery state: wear, capacity, degradation trend.
#
#   ./batcheck.sh              — snapshot + a line in batlog.csv (builds the trend)
#   ./batcheck.sh watch 14400  — watch: writes every sample to runs/,
#                                compares the power integral with energy_now
#   ./batcheck.sh sum runs/... — analyzes a saved run. Needed when
#                                the machine died mid-discharge and the summary
#                                did not get printed
#
# Root is not needed, everything is read from sysfs.
set -uo pipefail

MODE="${1:-snap}"
SECS="${2:-600}"
B=/sys/class/power_supply/BAT0
ADP=/sys/class/power_supply/ADP1
CSV="$(dirname "$0")/batlog.csv"

r() { cat "$1" 2>/dev/null; }

# ── analysis of a saved run ─────────────────────────────────────────────
if [ "$MODE" = sum ]; then
  F="${2:-}"
  [ -f "$F" ] || { echo "  ✗ specify a file: ./batcheck.sh sum runs/run_….csv"; exit 1; }
  echo "═══════════════════════════════════════════════════════"
  echo " RUN ANALYSIS: $(basename "$F")"
  echo "═══════════════════════════════════════════════════════"
  awk -F, -v design="$(r $B/energy_full_design)" -v full="$(r $B/energy_full)" 'NR==2{
      e_first=$3; c_first=$6; integ_first=$8 }
    NR>1 { e_last=$3; c_last=$6; el=$2; integ_last=$8; psum+=$4; pn++; mode[$7]++ }
    END {
      if (pn==0) { print "  file is empty"; exit 1 }
      # subtract the value of the first line from the integral: it accumulates from
      # script start, and the first sample lands only after an interval
      integ = integ_last - integ_first
      printf "  duration               : %.1f h (%d samples)\n", el/3600, pn
      # mode by majority across all lines, not by the status of the first line
      for (m in mode) if (mode[m] > best) { best = mode[m]; st = m }
      printf "  mode                   : %s (%d of %d samples)\n", st, best, pn
      printf "  charge                 : %s %% → %s %%\n", c_first, c_last
      printf "  average power          : %.2f W\n", psum/pn
      printf "  delivered by integral  : %.3f Wh\n", integ
      printf "  by energy_now counter  : %.3f Wh\n", e_first-e_last
      d = (e_first-e_last); d = (d<0? -d : d)
      if (integ>0.01) {
        printf "  discrepancy            : %.1f %%", 100*(d>integ? d-integ : integ-d)/integ
        # on short runs the difference drowns in the quantization of energy_now
        # (step ~1 mWh), comparing makes sense from half an hour up
        if (el < 1800) print "   — short run, this is quantization noise"
        else print (100*(d>integ? d-integ : integ-d)/integ < 5 ? "   ✔ counter is consistent" : "   ⚠ counter diverges")
      }
      dc = c_first - c_last
      if (dc >= 50) {
        printf "\n  ── Real capacity estimate ──\n"
        printf "  discharged by %d %% delivering %.2f Wh → full capacity ≈ %.1f Wh\n", dc, integ, integ*100/dc
        printf "  firmware currently says: %.1f Wh (design %.1f)\n", full/1e6, design/1e6
        printf "  → wear by measurement ≈ %.1f %%, by firmware %.1f %%\n", \
               100*(1-(integ*100/dc)*1e6/design), 100*(1-full/design)
      } else
        printf "\n  Discharged by only %d %%: a capacity estimate needs at least 50 %%,\n  otherwise the extrapolation lies.\n", dc
    }' "$F"
  echo "═══════════════════════════════════════════════════════"
  exit 0
fi

if [ ! -d "$B" ]; then echo "  ✗ $B not found"; exit 1; fi

design=$(r $B/energy_full_design); full=$(r $B/energy_full); now=$(r $B/energy_now)
volt=$(r $B/voltage_now); pw=$(r $B/power_now); st=$(r $B/status)
cap=$(r $B/capacity); cyc=$(r $B/cycle_count)

echo "═══════════════════════════════════════════════════════"
echo " BATTERY"
echo "═══════════════════════════════════════════════════════"
printf "  vendor / model         : %s / %s\n" "$(r $B/manufacturer)" "$(r $B/model_name)"
printf "  status                 : %s (%s %%), adapter %s\n" \
  "$st" "$cap" "$([ "$(r $ADP/online)" = 1 ] && echo "plugged in" || echo NO)"
echo
echo "── Capacity ──────────────────────────────────────────"
awk -v d="${design:-0}" -v f="${full:-0}" -v n="${now:-0}" 'BEGIN{
  printf "  design                 : %.2f Wh\n", d/1e6
  printf "  actual                 : %.2f Wh\n", f/1e6
  printf "  now in battery         : %.2f Wh\n", n/1e6
  if (d>0) {
    printf "  WEAR                   : %.1f %%   (%.1f %% of factory left)\n", 100*(1-f/d), 100*f/d
    printf "  lost                   : %.2f Wh\n", (d-f)/1e6 }}'
echo
echo "── Electrical ────────────────────────────────────────"
awk -v v="${volt:-0}" -v p="${pw:-0}" 'BEGIN{
  printf "  voltage                : %.3f V\n", v/1e6
  printf "  power                  : %.2f W\n", p/1e6 }'
printf "  charge cycles          : %s\n" "$([ "${cyc:-'-1'}" = "-1" ] && echo "firmware does not report" || echo "$cyc")"

# ── trend from the accumulated log ──────────────────────────────────────
if [ -f "$CSV" ] && [ "$(wc -l < "$CSV")" -gt 1 ]; then
  echo
  echo "── Trend ─────────────────────────────────────────────"
  awk -F, -v curf="${full:-0}" -v curd="${design:-0}" 'NR==2 {
      first_ts=$1; first_full=$3 }
    END {
      if (first_full>0 && curd>0) {
        w0=100*(1-first_full*1e6/curd); w1=100*(1-curf/curd)
        printf "  first record           : %s — wear %.1f %%\n", first_ts, w0
        printf "  now                    : wear %.1f %%  (%+.1f pp)\n", w1, w1-w0
      }}' "$CSV"
  printf "  records in the log     : %s\n" "$(( $(wc -l < "$CSV") - 1 ))"
fi

# ── watch mode ──────────────────────────────────────────────────────────
if [ "$MODE" = watch ]; then
  RUNS="$(dirname "$0")/runs"; mkdir -p "$RUNS"
  # The name is neutral on purpose: the status at startup says nothing about the
  # run. On Aug 3 the calibration discharge was started with the adapter plugged in,
  # and the file got named "charge" even though all 800 lines in it are Discharging.
  # The mode is now determined by `sum` from the data itself.
  RUN="$RUNS/run_$(date +%Y%m%d-%H%M%S).csv"
  echo "timestamp,elapsed_s,energy_wh,power_w,voltage_v,capacity_pct,status,integral_wh" > "$RUN"
  echo
  echo "── Watching for $SECS s ──────────────────────────────"
  echo "  Comparing the power integral with what the firmware writes to energy_now."
  echo "  A discrepancy of more than a few percent means the energy counter lies,"
  echo "  and then the wear figure cannot be trusted either."
  echo "  Every sample goes to $(basename "$RUN") right away: if the machine"
  echo "  shuts down on discharge, the data survives."
  e0="$now"; t0=$(date +%s); acc=0; prev_p="$pw"; prev_t="$t0"; n=0
  while [ $(( $(date +%s) - t0 )) -lt "$SECS" ]; do
    sleep 10
    p=$(r $B/power_now); t=$(date +%s)
    # trapezoid: average power over the interval × duration
    acc=$(awk -v a="$acc" -v p1="$prev_p" -v p2="${p:-0}" -v dt="$(( t - prev_t ))" \
          'BEGIN{ printf "%.0f", a + (p1+p2)/2*dt }')
    prev_p="${p:-0}"; prev_t="$t"; n=$((n+1))
    # a line is written on every sample: otherwise a discharge to cutoff loses everything
    awk -v ts="$(date -Iseconds)" -v el="$(( t - t0 ))" -v e="$(r $B/energy_now)" \
        -v p="${p:-0}" -v v="$(r $B/voltage_now)" -v c="$(r $B/capacity)" \
        -v s="$(r $B/status)" -v a="$acc" 'BEGIN{
      printf "%s,%d,%.3f,%.2f,%.3f,%s,%s,%.4f\n", ts, el, e/1e6, p/1e6, v/1e6, c, s, a/3600/1e6 }' >> "$RUN"
    printf "\r  samples: %-4s  elapsed: %-5s s  charge: %-3s %%  delivered: %s Wh " \
      "$n" "$(( t - t0 ))" "$(r $B/capacity)" \
      "$(awk -v a="$acc" 'BEGIN{printf "%.2f", a/3600/1e6}')"
  done
  echo
  e1=$(r $B/energy_now); t1=$(date +%s)
  echo "  Run: $RUN"
  awk -v a="$acc" -v e0="${e0:-0}" -v e1="${e1:-0}" -v dt="$(( t1 - t0 ))" -v st="$st" 'BEGIN{
    meas = a/3600/1e6              # power integral, Wh
    delta = (e1-e0)/1e6            # change according to firmware, Wh
    printf "  by power integral      : %.3f Wh\n", meas
    printf "  by energy_now counter  : %+.3f Wh\n", delta
    if (meas > 0.01) {
      d = (delta<0 ? -delta : delta)
      printf "  discrepancy            : %.1f %%", 100*(d-meas>0?d-meas:meas-d)/meas
      if (100*((d>meas?d-meas:meas-d))/meas < 5) print "   ✔ energy counter is consistent"
      else print "   ⚠ counter diverges, wear cannot be computed"
    } else print "  power near zero: the measurement is useless, load or discharge is needed" }'
fi

# ── writing to the log ──────────────────────────────────────────────────
[ -f "$CSV" ] || echo "timestamp,wear_pct,full_wh,design_wh,now_wh,capacity_pct,voltage_v,power_w,status,cycles" > "$CSV"
awk -v ts="$(date -Iseconds)" -v d="${design:-0}" -v f="${full:-0}" -v n="${now:-0}" \
    -v c="${cap:-0}" -v v="${volt:-0}" -v p="${pw:-0}" -v s="$st" -v cy="${cyc:-'-1'}" 'BEGIN{
  printf "%s,%.2f,%.3f,%.3f,%.3f,%s,%.3f,%.2f,%s,%s\n", ts, (d>0?100*(1-f/d):0), f/1e6, d/1e6, n/1e6, c, v/1e6, p/1e6, s, cy }' >> "$CSV"
echo
echo "  Written to $(basename "$CSV")"
echo "═══════════════════════════════════════════════════════"
