#!/usr/bin/env bash
# Analysis of one run: ./summary.sh runs/<directory>
# Computes statistics only over "loaded" seconds (GPU util >= 30%),
# so that idle time before/after the game does not dilute the averages.
set -uo pipefail
D="${1:?specify the run directory}"

echo "══════════════════════════════════════════════════════════════"
echo " RUN: $(basename "$D")"
echo "══════════════════════════════════════════════════════════════"
sed -n '2,$p' "$D/static.txt" 2>/dev/null | sed 's/^/  /'
echo

echo "── GPU (only seconds with util ≥ 30%) ────────────────────────"
awk -F',' '
  { gsub(/^ +| +$/,"",$2); gsub(/^ +| +$/,"",$3); gsub(/^ +| +$/,"",$5);
    gsub(/^ +| +$/,"",$7); gsub(/^ +| +$/,"",$9); gsub(/^ +| +$/,"",$10); gsub(/^ +| +$/,"",$11) }
  $5+0 >= 30 {
    n++; w+=$2; if($2+0>wm)wm=$2+0; if(wn==""||$2+0<wn)wn=$2+0
    c+=$3; if($3+0>cm)cm=$3+0
    u+=$5; t+=$7; if($7+0>tm)tm=$7+0
    gen[$9]++; wid[$10]++; reasons[$11]++
  }
  END{
    if(n==0){print "  no seconds under load (did the game not run?)"; exit}
    printf "  samples under load    : %d s\n", n
    printf "  GPU power             : avg %.1f W | max %.1f W | min %.1f W\n", w/n, wm, wn
    printf "  SM clock              : avg %.0f MHz | max %.0f MHz  (ceiling 2100)\n", c/n, cm
    printf "  GPU utilization       : avg %.0f %%\n", u/n
    printf "  temperature           : avg %.0f °C | max %.0f °C  (slowdown 97)\n", t/n, tm
    printf "  PCIe gen/width        : "; for(k in gen) printf "gen%s×%d s ", k, gen[k];
    for(k in wid) printf "| x%s×%d s ", k, wid[k]; printf "\n"
    printf "  throttle reasons      :\n"
    for(k in reasons) printf "      %s  — %d s\n", k, reasons[k]
  }' "$D/gpu.csv"
echo
echo "  Decoding the clocks_event_reasons bits:"
echo "     0x1 GpuIdle   0x4 SwPowerCap(hit the driver's power limit)"
echo "     0x8 HwSlowdown  0x40 SwThermalSlowdown"
echo "     0x80 HwThermalSlowdown  0x100 HwPowerBrakeSlowdown(the EC cut the power!)"
echo

echo "── CPU / platform ────────────────────────────────────────────"
awk -F',' 'NR>1 && $2!="" {
    n++; p+=$2; if($2+0>pm)pm=$2+0
    s+=$3; if($3+0>sm)sm=$3+0
    f+=$5; if($5+0>fm)fm=$5+0
    t+=$6; if($6+0>tm)tm=$6+0
    b+=$10; bs[$8]++
    last_thr=$12; if(first_thr=="")first_thr=$12
    lastcore=$13; if(firstcore=="")firstcore=$13
  }
  END{
    if(n==0){print "  no RAPL data"; exit}
    printf "  CPU package power     : avg %.1f W | max %.1f W   (PL1=52 W, PL2=64 W)\n", p/n, pm
    printf "  PSYS power (whole platform): avg %.1f W | max %.1f W   (limit 56 W)\n", s/n, sm
    printf "  CPU clock (top core)  : avg %.0f MHz | peak %.0f MHz\n", f/n, fm
    printf "  package temperature   : avg %.0f °C | max %.0f °C\n", t/n, tm
    printf "  battery power         : avg %.1f W  (>0 while charging = eats the adapter budget)\n", b/n
    printf "  battery state         : "; for(k in bs) printf "%s×%ds ", k, bs[k]; printf "\n"
    printf "  package_throttle growth: %d   core_throttle: %d\n", last_thr-first_thr, lastcore-firstcore
  }' "$D/sys.csv"
echo

echo "── THE MAIN QUESTION: where did the budget go ────────────────"
gpu_avg=$(awk -F',' '{gsub(/ /,"",$2);gsub(/ /,"",$5)} $5+0>=30 {n++;w+=$2} END{if(n)printf "%.1f",w/n; else print 0}' "$D/gpu.csv")
awk -F',' -v g="$gpu_avg" 'NR>1 && $2!="" {n++;p+=$2;b+=$10} END{
  if(!n){print "  no data"; exit}
  cpu=p/n; bat=b/n; tot=cpu+g+bat
  printf "  CPU package    %6.1f W\n", cpu
  printf "  GPU            %6.1f W\n", g
  printf "  battery charge %6.1f W\n", bat
  printf "  ─────────────────────────\n"
  printf "  TOTAL from adapter ≈ %.1f W (+ screen/SSD/Wi-Fi ≈ 8–12 W)\n", tot
  printf "  → adapter load ≈ %.0f W\n", tot+10
  if (tot+10 > 95) print "  ⚠ HITTING THE 100 W ADAPTER: the EC will cut the GPU."
  if (bat > 5 && g < 25) print "  ⚠ The battery is charging while the GPU falls short: a strong sign of budget sharing."
}' "$D/sys.csv"
echo "══════════════════════════════════════════════════════════════"
