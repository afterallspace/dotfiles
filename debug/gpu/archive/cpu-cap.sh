#!/usr/bin/env bash
# Limit/restore the CPU power budget. Needed to test the hypothesis
# "the CPU takes power away from the GPU".
#
#   sudo ./cpu-cap.sh 30 40   — PL1=30 W, PL2=40 W (just right for games)
#   sudo ./cpu-cap.sh restore — restore the factory 52/64 W
#   ./cpu-cap.sh show         — show current values
#
# Everything lasts until a reboot. Breaks nothing, flashes nothing.
set -uo pipefail
P=/sys/class/powercap/intel-rapl:0

show() {
  echo "PL1 (long_term)  = $(awk '{printf "%.0f W", $1/1e6}' $P/constraint_0_power_limit_uw)"
  echo "PL2 (short_term) = $(awk '{printf "%.0f W", $1/1e6}' $P/constraint_1_power_limit_uw)"
  echo "PSYS limit       = $(awk '{printf "%.0f W", $1/1e6}' /sys/class/powercap/intel-rapl:1/constraint_0_power_limit_uw 2>/dev/null)"
  echo "GPU limit        = $(nvidia-smi --query-gpu=power.default_limit --format=csv,noheader)"
  echo "platform_profile = $(cat /sys/firmware/acpi/platform_profile)"
}

case "${1:-show}" in
  show) show ;;
  restore)
    [ "$EUID" -eq 0 ] || { echo "sudo required"; exit 1; }
    echo 52000000 > $P/constraint_0_power_limit_uw
    echo 64000000 > $P/constraint_1_power_limit_uw
    echo "Restored factory values:"; show ;;
  *)
    [ "$EUID" -eq 0 ] || { echo "sudo required"; exit 1; }
    PL1="${1:?PL1 in watts}"; PL2="${2:-$((PL1 + 10))}"
    echo $((PL1 * 1000000)) > $P/constraint_0_power_limit_uw
    echo $((PL2 * 1000000)) > $P/constraint_1_power_limit_uw
    echo "Set:"; show ;;
esac
