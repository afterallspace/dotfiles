#!/usr/bin/env bash
# Live view of the ACPI variables behind the GPU power-lock mechanism
# (see acpi/ssdt16.dsl and SOLUTION.md). Requires the acpi_call module:
#   sudo pacman -S acpi_call-dkms && sudo modprobe acpi_call
#   sudo ./nvpcf-peek.sh          # read-only
#   sudo ./nvpcf-peek.sh --dsm    # + call NVPCF _DSM sub-func#2 directly
#   sudo ./nvpcf-peek.sh --kick   # + fire EC handler _Q24 (CAUTION: locks
#                                 #   the card if EC currently reports STNM=2)
set -u
CALL=/proc/acpi/call
[ -w "$CALL" ] 2>/dev/null || { echo "no $CALL - install acpi_call and modprobe it"; exit 1; }

peek() { # peek <acpi-path> <description>
  printf '%s' "$1" > "$CALL" 2>/dev/null
  local v; v=$(tr -d '\0' < "$CALL")
  printf "  %-32s %-12s %s\n" "${1##*.}" "$v" "$2"
}

echo "== EC / platform =="
peek '\_SB.PC00.LPCB.H_EC.STNM' "EC mode: _Q24 branch selector (2 locks, 1/3 unlock)"
peek '\PDFG'                    "config flag, bit3 selects factory TPP 15/20 W"

echo "== NOPR gates (set by BIOS at POST) =="
peek '\_SB.PC00.PEG0.PEGP.NPCS' "NVPCF _DSM gate"
peek '\_SB.PC00.PEG0.PEGP.GPSS' "GPS (PlatformRequestHandler) _DSM gate"
peek '\_SB.PC00.PEG0.PEGP.GC6S' "JT (GC6) gate"
peek '\_SB.PC00.PEG0.PEGP.NBCS' "NBCI gate"

echo "== NPCF variables (units of 1/8 W) =="
peek '\_SB.NPCF.DBAC' "Dynamic Boost AC (1=on)"
peek '\_SB.NPCF.DBDC' "Dynamic Boost DC (1=on)"
peek '\_SB.NPCF.ACBT' "CTGP offset AC"
peek '\_SB.NPCF.DCBT' "CTGP offset DC"
peek '\_SB.NPCF.AMAT' "max boost offset AC"
peek '\_SB.NPCF.AMIT' "min boost offset AC"
peek '\_SB.NPCF.ATPP' "TPP AC (0x78=15W / 0xA0=20W factory values)"
peek '\_SB.NPCF.DTPP' "TPP DC (0 = powerd's 'DC table not supported')"
peek '\_SB.NPCF.CUSL' "custom limit written by driver (sub-func#5)"
peek '\_SB.NPCF.CUCT' "custom ctgp written by driver"

if [ "${1:-}" = "--dsm" ]; then
  echo
  echo "== live NVPCF sub-func#2 reply (what the GSP actually reads) =="
  zeros=$(printf '00%.0s' $(seq 49))
  printf '%s' "\\_SB.NPCF.NPCF b00000000000000000000000000000000 0x0200 2 b$zeros" > "$CALL"
  out=$(tr -d '\0' < "$CALL")
  echo "$out" | fold -w 76
  echo "$out" | awk -F', ' '{
    gsub(/[{}]/,"");
    pc02=strtonum($23); tppa=strtonum($26)+strtonum($27)*256; tgpa=strtonum($6)+strtonum($7)*256;
    printf "  PC02 (boost controller): %d (0=off)\n", pc02;
    printf "  TGPA (CTGP offset):      %d/8 W\n", tgpa;
    printf "  TPPA (TPP AC):           %d/8 = %.0f W\n", tppa, tppa/8;
  }'
fi

if [ "${1:-}" = "--kick" ]; then
  echo "== firing \\_SB.PC00.LPCB.H_EC._Q24 =="
  printf '%s' '\_SB.PC00.LPCB.H_EC._Q24' > "$CALL"
  tr -d '\0' < "$CALL"; echo
  echo "watch clocks in nvidia-smi (locked ~1327 MHz, free 1600+)"
fi
