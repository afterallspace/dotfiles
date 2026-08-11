#!/usr/bin/env bash
# Power path check: what the charger really delivers, how the battery behaves.
# RUN WITH THE ADAPTER PLUGGED IN, otherwise the USB-C PD fields will be zero.
#
#   ./powercheck.sh          — snapshot
#   ./powercheck.sh 30       — watch for 30 seconds (catches dips)
set -uo pipefail
SECS="${1:-0}"

BAT=/sys/class/power_supply/BAT0
ADP=/sys/class/power_supply/ADP1
UCSI=$(ls -d /sys/class/power_supply/ucsi-source-psy-* 2>/dev/null | head -1)
TYPEC=/sys/class/typec/port0

r() { cat "$1" 2>/dev/null; }

echo "═══════════════════════════════════════════════════════"
echo " POWER PATH"
echo "═══════════════════════════════════════════════════════"

ac=$(r $ADP/online)
printf "  Adapter connected      : %s\n" "$([ "$ac" = 1 ] && echo yes || echo NO)"
[ "$ac" != 1 ] && echo "  ⚠ Plug in the adapter, PD data is meaningless without it."

echo
echo "── USB-C Power Delivery ──────────────────────────────"
if [ ! -d "$TYPEC" ] && [ -z "$UCSI" ]; then
  # Aug 13: the ucsi_acpi module is blacklisted on purpose. This is NOT a measurement failure:
  # the firmware returned nothing but zeros and spewed ~2 lines/s into the kernel log.
  echo "  UCSI unloaded on purpose (blacklist ucsi_acpi), no PD fields."
  echo "  Why this is no loss: SOLUTION.md → \"UCSI: log storm\"."
else
  pom=$(r $TYPEC/power_operation_mode)
  bw=$(r $BAT/power_now)
  printf "  port power mode        : %s\n" "${pom:-—}"
  case "$pom" in
    usb_power_delivery) echo "                           ✔ PD contract negotiated" ;;
    default)
      if [ "$ac" = 1 ]; then
        # Aug 13: the field showed 'default' (≤15 W) while the battery was taking 22 W:
        # the firmware lies. Complain about PD only if the draw confirms it.
        if [ "${bw:-0}" -gt 15000000 ] 2>/dev/null; then
          printf "                           ⚠ field lies: 'default' (≤15 W), yet the battery takes %s W\n" \
            "$(awk -v x="$bw" 'BEGIN{printf "%.1f", x/1e6}')"
        else
          echo "                           ⚠ ONLY default 5 V USB — PD NOT negotiated!"
        fi
      fi
      ;;
  esac
  printf "  PD revision            : %s\n" "$(r $TYPEC/usb_power_delivery_revision)"
  printf "  power role             : %s\n" "$(r $TYPEC/power_role)"
  if [ -n "$UCSI" ]; then
    u_v=$(r $UCSI/voltage_now); u_i=$(r $UCSI/current_now)
    u_vm=$(r $UCSI/voltage_max); u_im=$(r $UCSI/current_max)
    printf "  source: now            : %s V, %s A" \
      "$(awk -v x="${u_v:-0}" 'BEGIN{printf "%.1f", x/1e6}')" \
      "$(awk -v x="${u_i:-0}" 'BEGIN{printf "%.2f", x/1e6}')"
    awk -v v="${u_v:-0}" -v i="${u_i:-0}" 'BEGIN{ if(v>0&&i>0) printf "  →  %.1f W\n", v*i/1e12; else print "" }'
    printf "  source: maximum        : %s V, %s A" \
      "$(awk -v x="${u_vm:-0}" 'BEGIN{printf "%.1f", x/1e6}')" \
      "$(awk -v x="${u_im:-0}" 'BEGIN{printf "%.2f", x/1e6}')"
    awk -v v="${u_vm:-0}" -v i="${u_im:-0}" 'BEGIN{ if(v>0&&i>0) printf "  →  %.0f W (adapter rating)\n", v*i/1e12; else print "" }'
    [ "${u_vm:-0}" = 0 ] && [ "$ac" = 1 ] && \
      echo "  ⚠ The firmware does not report source parameters, the adapter rating cannot be read."
  fi
fi

echo
echo "── Battery ───────────────────────────────────────────"
ef=$(r $BAT/energy_full); ed=$(r $BAT/energy_full_design)
printf "  status                 : %s (%s %%)\n" "$(r $BAT/status)" "$(r $BAT/capacity)"
printf "  voltage                : %s V (design min %s V)\n" \
  "$(awk -v x="$(r $BAT/voltage_now)" 'BEGIN{printf "%.2f", x/1e6}')" \
  "$(awk -v x="$(r $BAT/voltage_min_design)" 'BEGIN{printf "%.2f", x/1e6}')"
printf "  power                  : %s W\n" \
  "$(awk -v x="$(r $BAT/power_now)" 'BEGIN{printf "%.1f", x/1e6}')"
awk -v f="${ef:-0}" -v d="${ed:-0}" 'BEGIN{
  if(d>0){ printf "  capacity               : %.1f / %.1f Wh = %.0f %% of factory", f/1e6, d/1e6, 100*f/d;
           if(100*f/d < 70) print "  ⚠ heavy wear"; else print "" }}'

echo
echo "── Adapter load ──────────────────────────────────────"
psys=$(r /sys/class/powercap/intel-rapl:1/energy_uj)
if [ -n "$psys" ]; then
  sleep 1
  psys2=$(r /sys/class/powercap/intel-rapl:1/energy_uj)
  awk -v a="$psys" -v b="$psys2" 'BEGIN{printf "  platform (PSYS)        : %.1f W\n", (b-a)/1e6}'
else
  echo "  platform (PSYS)        : no access (needs sudo chmod a+r .../energy_uj)"
fi
printf "  GPU                    : %s\n" "$(nvidia-smi --query-gpu=power.draw.instant --format=csv,noheader 2>/dev/null)"

if [ "$SECS" -gt 0 ] 2>/dev/null; then
  echo
  echo "── Watching for $SECS s (looking for dips and discharge with the adapter in) ──"
  printf "  %-9s %-14s %9s %8s %8s\n" TIME STATUS VOLTAGE BAT_W AC
  end=$(( $(date +%s) + SECS ))
  while [ "$(date +%s)" -lt "$end" ]; do
    printf "  %-9s %-14s %7s V %6s W %8s\n" "$(date +%H:%M:%S)" "$(r $BAT/status)" \
      "$(awk -v x="$(r $BAT/voltage_now)" 'BEGIN{printf "%.2f", x/1e6}')" \
      "$(awk -v x="$(r $BAT/power_now)" 'BEGIN{printf "%.1f", x/1e6}')" \
      "$(r $ADP/online)"
    sleep 2
  done
  echo
  echo "  What to look for: 'Discharging' lines at AC=1 under load mean"
  echo "  the adapter does not cover consumption — then the adapter or cable is to blame."
fi
echo "═══════════════════════════════════════════════════════"
