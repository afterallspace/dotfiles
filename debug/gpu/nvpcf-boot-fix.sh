#!/bin/bash
# Unlock GPU boost clocks on Xiaomi Book Pro 16 2022 (RTX 2050).
#
# Root cause (see SOLUTION.md / BUGREPORT.md): on most boots the GSP firmware
# ends up with boost clocks (PM1) forbidden -> SM clock capped at ~1327 MHz,
# ~17 W. The only reliable fix found: drive the EC mode register STNM through
# the stock EC query handler _Q24 twice, in this exact order:
#     \NVST 3  -> wait ~20 s ->  \NVST 1
# (NVST = write STNM + invoke _Q24; provided by the runtime SSDT
#  nvpcf-stnm.aml loaded via configfs. Validated repeatedly on 2026-07-22.)
#
# Must run while the dGPU is under load (the session wrapper handles that).
# Installed as a root-owned copy in /usr/local/bin (sudoers NOPASSWD entry).
set -u
AMLDIR=/usr/local/share/nvpcf-fix
CALL=/proc/acpi/call
CFG=/sys/kernel/config/acpi/table
log() { echo "nvpcf-boot-fix: $*"; }

[ "$(id -u)" = 0 ] || { log "must run as root"; exit 1; }
modprobe acpi_call 2>/dev/null
modprobe acpi_configfs 2>/dev/null
[ -w "$CALL" ] || { log "no $CALL (acpi_call module not loaded)"; exit 1; }

if [ ! -d "$CFG/nvpcfstnm" ]; then
  mkdir -p "$CFG/nvpcfstnm" 2>/dev/null
  cat "$AMLDIR/nvpcf-stnm.aml" > "$CFG/nvpcfstnm/aml" 2>/dev/null \
    || { log "failed to load $AMLDIR/nvpcf-stnm.aml"; exit 1; }
  log "SSDT nvpcf-stnm loaded (evaporates on reboot)"
fi

inv() { printf '%s' "$1" > "$CALL"; tr -d '\0' < "$CALL"; }
log "step 1: NVST 3 -> $(inv '\NVST 3')"
sleep 20
log "step 2: NVST 1 -> $(inv '\NVST 1')"
sleep 2
log "final STNM=$(inv '\_SB.PC00.LPCB.H_EC.STNM')"
