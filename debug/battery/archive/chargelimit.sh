#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════╗
# ║ ARCHIVE. Closed 2026-08-05: the SMI handler in BIOS XMAAD6B0P1717    ║
# ║ accepts the call and does NOT implement group 0x10. This cannot set  ║
# ║ a charge limit. The script works and stays as a re-check in case of  ║
# ║ a new BIOS: `diag` and `smi` give a verdict in a couple of minutes.  ║
# ║ Analysis: ../BATTERY.md, "Charge limit: investigation closed".       ║
# ╚══════════════════════════════════════════════════════════════════════╝
#
# Battery charge limit through MIFS WMI (Xiaomi/Redmi, ODM Bitland).
#
#   sudo ./chargelimit.sh              — status: limit, health, adapter
#   sudo ./chargelimit.sh diag         — is the transport alive at all, READ ONLY
#   sudo ./chargelimit.sh calib        — find the response layout via hwmon, READ
#   sudo ./chargelimit.sh probe        — sweep of firmware functions, READ ONLY
#   sudo ./chargelimit.sh raw FA 10 02 00 — one call, raw response bytes
#   sudo ./chargelimit.sh set 80       — set the limit to 40/50/60/70/80
#   sudo ./chargelimit.sh off          — remove the limit (100 %)
#
# Needs root: writes to /proc/acpi/call (acpi_call module).
#
# ── Protocol ───────────────────────────────────────────────────────────
# The \_SB.PC00.WMID.WMAA method is the WMI method MiInterface of class
# MiCommonInterface, GUID B60BFB48-3E5B-49E4-A0E9-8CFFE1B3434B. Signature
# WMAA(instance, method_id, buffer) → WMAA 0x0 0x1 { 32 bytes }.
#
# Input buffer (the first 8 bytes matter, the other 24 are zeros):
#   [1] operation    0xFA = GET, 0xFB = SET
#   [3] command      0x10 = charge protection group
#   [4] sub-function 0x01 health, 0x02 limit, 0x03 zone, 0x06 adapter watts
#   [6] value
# Response: OUT[1] = 0x80 supported / 0xE0 not, OUT[6] = value of group 0x10.
#
# Limit codes (not percentages!): 0→100 %, 1→80 % (legacy), 4→80 % (granular),
# 5→70 %, 6→60 %, 7→50 %, 8→40 %. Granular scale: % = 120 − code·10.
# There is no code for 90 %, the firmware rejects it.
#
# Source of the decoding: reverse engineering of Xiaomi PC Manager in XiControl
# (github.com/Oksion/XiControl, docs/01-wmi-protocol.md and 12-charge-levels.md),
# checked against the bitland-mifs-wmi kernel driver and _WDG/WQAB from this
# machine's ssdt8.dsl. The ArchWiki recipe's bytes fit the same format.
#
# ⚠ The EC holds the limit and LOSES it on power transitions (sleep, hibernation,
#   AC↔battery) and on reboot. It needs re-arming, see BATTERY.md.
#
# ⚠ DO NOT WRITE to /sys/bus/wmi/devices/B60BFB48-*/kb_mode. The kernel driver
#   treats command 0x10 as "RGB keyboard mode" and puts the value in the same
#   byte [4], so writing kb_mode=fixed is SET 0x10/02 val=0, which removes the
#   limit. On this machine the attribute controls charging, not the backlight.
set -uo pipefail

CALL=/proc/acpi/call
WMAA='\_SB.PC00.WMID.WMAA'
CMD_CHARGE=0x10
SUB_HEALTH=0x01
SUB_LIMIT=0x02
SUB_ZONE=0x03
SUB_WATTS=0x06
LOCK=/run/lock/mifs-wmaa.lock

die() { echo "  ✗ $*" >&2; exit 1; }

[ "$(id -u)" = 0 ] || die "root required: sudo $0 $*"

if [ ! -e "$CALL" ]; then
  modprobe acpi_call 2>/dev/null
  [ -e "$CALL" ] || die "no $CALL: the acpi_call module did not load (pacman -S acpi_call-dkms)"
fi

# ── One MiInterface call ───────────────────────────────────────────────
# mifs <op> <cmd> <arg> <val> → prints 30 response bytes as "00 80 00 10 …"
# Fails rather than returning zeros: a silent zero has already once cost
# a false verdict in the neighboring branch.
OUT=()
mifs() {
  local op=$1 cmd=$2 arg=$3 val=$4 head pad raw i
  printf -v head '0x00 0x%02x 0x00 0x%02x 0x%02x 0x00 0x%02x 0x00' \
    "$((op))" "$((cmd))" "$((arg))" "$((val))"
  pad=$(printf '0x00 %.0s' $(seq 24))

  # /proc/acpi/call is one for the whole system, and the bitland-mifs-wmi driver
  # uses it too: at least serialize our own calls with each other
  exec 9>"$LOCK" || die "cannot open $LOCK"
  flock 9 || die "cannot take lock $LOCK"
  echo "$WMAA 0x0 0x1 { $head $pad}" > "$CALL" || die "write to $CALL failed"
  raw=$(tr -d '\0' < "$CALL")
  exec 9>&-

  case "$raw" in
    '' )        die "empty response from $CALL" ;;
    Error*)     die "ACPI returned: $raw" ;;
    'not called'*) die "acpi_call says \"not called\": the call did not go through" ;;
    '{'*)       ;;
    *)          die "unexpected response from $CALL: $raw" ;;
  esac

  # "{0x00, 0x80, …}" → array
  raw=${raw#\{}; raw=${raw%\}}; raw=${raw//,/ }
  OUT=()
  for i in $raw; do OUT+=("$((i))"); done
  [ "${#OUT[@]}" -ge 7 ] || die "response shorter than 7 bytes (${#OUT[@]}), nothing to parse"
}

# Call with a status check. Returns 1 if the function is not supported.
mifs_ok() {
  mifs "$@"
  [ "${OUT[1]}" = 128 ]
}

# Response as one hex line, so there is no guessing about the layout
out_hex() {
  local i
  for i in "${!OUT[@]}"; do printf '%02x ' "${OUT[$i]}"; done
  echo
}
# Indices above the bytes: ── 0  1  2  3 …
out_ruler() {
  local i
  for i in "${!OUT[@]}"; do printf '%2d ' "$i"; done
  echo
}

# ── Limit code tables ──────────────────────────────────────────────────
code_to_pct() {
  case "$1" in
    0) echo 100 ;; 1) echo 80 ;; 4) echo 80 ;;
    5) echo 70 ;;  6) echo 60 ;; 7) echo 50 ;; 8) echo 40 ;;
    *) return 1 ;;
  esac
}
pct_to_code() {
  case "$1" in
    100) echo 0 ;; 80) echo 1 ;; 70) echo 5 ;;
    60) echo 6 ;;  50) echo 7 ;; 40) echo 8 ;;
    *) return 1 ;;
  esac
}

hdr() {
  echo "═══════════════════════════════════════════════════════"
  echo " $1"
  echo "═══════════════════════════════════════════════════════"
}

B=/sys/class/power_supply/BAT0
ADP=/sys/class/power_supply/ADP1
r() { cat "$1" 2>/dev/null; }

# ── Status ─────────────────────────────────────────────────────────────
show_status() {
  hdr "CHARGE LIMIT — MIFS 0x10"

  if ! mifs_ok 0xFA $CMD_CHARGE $SUB_LIMIT 0; then
    printf "  status in OUT[1] = 0x%02x, expected 0x80 (present) or 0xE0 (absent)\n" "${OUT[1]}"
    echo "  Raw response:"
    echo -n "    "; out_ruler
    echo -n "    "; out_hex
    echo
    echo "  This is NOT a \"no limit\" verdict: the firmware's response layout"
    echo "  differs from TM2424. Calibrate first: ./chargelimit.sh calib"
    return 1
  fi

  local code=${OUT[6]} pct
  if pct=$(code_to_pct "$code"); then
    if [ "$pct" = 100 ]; then
      printf "  charge limit           : none (code %d)\n" "$code"
    else
      printf "  charge limit           : %d %% (code %d)\n" "$pct" "$code"
    fi
  else
    printf "  charge limit           : code %d, outside the known table\n" "$code"
  fi

  if mifs_ok 0xFA $CMD_CHARGE $SUB_HEALTH 0; then
    printf "  firmware health        : %d %% of original capacity\n" "${OUT[6]}"
  else
    echo "  firmware health        : not supported (0x10/01)"
  fi

  if mifs_ok 0xFA $CMD_CHARGE $SUB_ZONE 0; then
    printf "  charge zone indicator  : %d\n" "${OUT[6]}"
  fi

  if mifs_ok 0xFA $CMD_CHARGE $SUB_WATTS 0; then
    local w=${OUT[6]}
    if [ "$w" = 0 ]; then
      echo "  adapter                : no power or a non-PD adapter"
    else
      printf "  adapter (PD)           : %d W\n" "$w"
    fi
  fi

  echo
  echo "── Battery via sysfs ─────────────────────────────────"
  printf "  status                 : %s (%s %%), adapter %s\n" \
    "$(r $B/status)" "$(r $B/capacity)" \
    "$([ "$(r $ADP/online)" = 1 ] && echo "plugged in" || echo NO)"
  local design full
  design=$(r $B/energy_full_design); full=$(r $B/energy_full)
  if [ -n "$design" ] && [ -n "$full" ]; then
    awk -v d="$design" -v f="$full" 'BEGIN{
      printf "  capacity               : %.2f of %.2f Wh (wear %.1f %%)\n",
             f/1e6, d/1e6, 100*(1-f/d) }'
  fi
  echo "═══════════════════════════════════════════════════════"
}

# ── Writing the limit ──────────────────────────────────────────────────
# Re-arm off→on: first 100 %, a pause, then the code. The OEM does this too:
# writing zero resets the EC's charging state machine.
apply() {
  local code=$1 pct=$2 got

  mifs_ok 0xFB $CMD_CHARGE $SUB_LIMIT 0 \
    || die "firmware rejected the limit reset (OUT[1]=$(printf 0x%02x "${OUT[1]}"))"

  if [ "$code" != 0 ]; then
    sleep 0.08
    mifs_ok 0xFB $CMD_CHARGE $SUB_LIMIT "$code" \
      || die "firmware rejected code $code (OUT[1]=$(printf 0x%02x "${OUT[1]}")): limit $pct % is not supported on this model"
  fi

  # Verify by reading back: without it "set" means nothing
  mifs_ok 0xFA $CMD_CHARGE $SUB_LIMIT 0 || die "cannot read the limit back"
  got=${OUT[6]}
  [ "$got" = "$code" ] \
    || die "readback mismatch: wrote code $code, firmware holds $got"

  if [ "$code" = 0 ]; then
    echo "  ✔ limit removed, charging to 100 %"
  else
    echo "  ✔ limit $pct % set and confirmed by reading back (code $code)"
    echo
    echo "  The limit lives in the EC and is lost on power transitions and on"
    echo "  reboot: it needs re-arming, see BATTERY.md."
  fi
}

# ── Sweep: what does the firmware answer at all. GET ONLY, nothing is written ───
probe() {
  hdr "MIFS FUNCTION SWEEP (read only)"
  echo "  Nothing is written: all calls are 0xFA/GET."
  echo
  echo "── Sub-functions of charge group 0x10 ────────────────"
  local a c
  for a in 0 1 2 3 4 5 6 7 8; do
    mifs 0xFA $CMD_CHARGE "$a" 0
    printf "  0x10/%02x : status 0x%02x  OUT[4]=%-4d OUT[6]=%-4d %s\n" \
      "$a" "${OUT[1]}" "${OUT[4]}" "${OUT[6]}" \
      "$([ "${OUT[1]}" = 128 ] && echo supported || echo —)"
  done

  echo
  echo "── Commands 0x01…0x30, arg=0 ─────────────────────────"
  for c in $(seq 1 48); do
    mifs 0xFA "$c" 0 0
    [ "${OUT[1]}" = 128 ] || continue
    printf "  cmd 0x%02x : supported, OUT[4]=%-4d OUT[6]=%-4d\n" \
      "$c" "${OUT[4]}" "${OUT[6]}"
  done
  echo "═══════════════════════════════════════════════════════"
}

# ── Response layout calibration ────────────────────────────────────────
# The only way not to guess: the same WMAA method reads fan speeds
# and CPU temperature, and the result of those reads is already visible in
# hwmon, because the bitland-mifs-wmi kernel driver does them itself. Compare the
# raw response with numbers known to be correct and find at which indices the
# payload sits on THIS firmware.
#
# Layout per the driver (its data[] starts at byte 4):
#   cmd 0x0D: CPU RPM = [4][5], GPU RPM = [6][7], SYS RPM = [10][11], LE
#   cmd 0x16: CPU temperature = [4], °C
calib() {
  hdr "RESPONSE LAYOUT CALIBRATION (read only)"

  local hw name f
  for f in /sys/class/hwmon/hwmon*; do
    [ "$(r "$f/name")" = bitland_mifs ] && hw=$f && break
  done
  [ -n "${hw:-}" ] || die "no hwmon named bitland_mifs found: did the driver not bind?"

  echo "  Reference from hwmon ($hw), written by the kernel driver through the same method:"
  local fan1 fan2 fan3 temp ref_ok=1
  fan1=$(r "$hw/fan1_input"); fan2=$(r "$hw/fan2_input"); fan3=$(r "$hw/fan3_input")
  temp=$(r "$hw/temp1_input")
  [ -n "$fan1" ] || die "cannot read $hw/fan1_input"
  [ -n "$temp" ] || die "cannot read $hw/temp1_input"
  printf "    fans        : CPU %s, GPU %s, SYS %s RPM\n" "$fan1" "$fan2" "$fan3"
  printf "    temperature : %d °C\n" $((temp / 1000))

  # Zero is no good as a reference: it means "not read", not "cold".
  # Checking the layout against zeros is exactly the silent zero that has
  # already once given a false verdict in the nvme branch.
  if [ "$fan1" = 0 ] && [ "$temp" = 0 ]; then
    ref_ok=0
    echo
    echo "  ⚠ EMPTY REFERENCE. 0 °C with a running CPU is not a measurement,"
    echo "    it is \"not read\": the kernel driver gets nothing but zeros through"
    echo "    this same method. There is nothing to check the layout against, below are"
    echo "    only raw dumps, without matching."
  fi
  echo

  # ── Echo test: is SMI alive at all ───────────────────────────────────
  # Send a pattern that never occurs in a meaningful response. If it comes back
  # (even shifted), the SMI handler did not run, and we are reading
  # our own buffer from shared memory. If the response differs, the firmware
  # computed something, and the layout is worth looking for.
  echo "── Echo test: 0xFA cmd=0xAA arg=0xBB val=0xCC ────────"
  mifs 0xFA 0xAA 0xBB 0xCC
  echo "    IN : 00 fa 00 aa bb 00 cc 00"
  echo -n "    ── "; out_ruler
  echo -n "    OUT "; out_hex
  local joined=" $(out_hex)"
  if [[ "$joined" == *" aa "* && "$joined" == *" bb "* && "$joined" == *" cc "* ]]; then
    echo "    ✗ THE PATTERN CAME BACK WHOLE: this is an echo of our own buffer."
    echo "      The SMI handler did not run: we write to shared memory and"
    echo "      read it back. The interface is dead on this firmware."
  else
    echo "    ✔ the pattern did not come back: the firmware answered with something of its own,"
    echo "      so the handler is alive and the layout is worth looking for"
  fi
  echo

  echo "── GET cmd 0x0D (fan speeds) ─────────────────────────"
  mifs 0xFA 0x0D 0 0
  echo -n "    "; out_ruler
  echo -n "    "; out_hex
  local i lo hi v hit=0
  if [ "$ref_ok" = 1 ]; then
    echo "  Looking for $fan1 as 16-bit little-endian:"
    for i in $(seq 0 $((${#OUT[@]} - 2))); do
      lo=${OUT[$i]}; hi=${OUT[$((i+1))]}; v=$((lo + hi * 256))
      if [ "$v" = "$fan1" ]; then
        printf "    ✔ CPU RPM (%s) is in bytes [%d][%d]\n" "$fan1" "$i" "$((i+1))"
        printf "      → payload offset: %+d relative to the TM2424 layout ([4][5] there)\n" "$((i - 4))"
        hit=1
      fi
    done
    [ "$hit" = 1 ] || echo "    ✗ value $fan1 is not in the response: the speed changed between reads or the layout is more complex"
  fi

  echo
  echo "── GET cmd 0x16 (CPU temperature) ────────────────────"
  mifs 0xFA 0x16 0 0
  echo -n "    "; out_ruler
  echo -n "    "; out_hex
  if [ "$ref_ok" = 1 ]; then
    local t=$((temp / 1000))
    echo "  Looking for $t (±2 °C, it was read at a different moment):"
    hit=0
    for i in "${!OUT[@]}"; do
      v=${OUT[$i]}
      if [ "$v" -ge $((t - 2)) ] && [ "$v" -le $((t + 2)) ]; then
        printf "    • candidate: byte [%d] = %d\n" "$i" "$v"
        hit=1
      fi
    done
    [ "$hit" = 1 ] || echo "    ✗ no similar value"
  fi

  echo
  echo "── GET cmd 0x10 sub 0x00…0x08 (charge group) ─────────"
  local a
  for a in 0 1 2 3 4 5 6 7 8; do
    mifs 0xFA $CMD_CHARGE "$a" 0
    printf "  0x10/%02x : " "$a"; out_hex
  done
  echo "═══════════════════════════════════════════════════════"
}

# ── Transport diagnostics ──────────────────────────────────────────────
# acpi_call can evaluate not only methods but also named objects,
# including OperationRegion fields. Read the interface's service fields
# directly and see whether the transport works at all.
#
# Layout of region XGNS (SystemMemory 0x44A61000, 42 bytes, lies in
# ACPI NVS, firmware memory, right after the FACS table):
#   MTID  8 bit   offset 0      method id, set before SMI
#   WMIB  256 bit offsets 1-32  request/response buffer
#   CTID  16 bit  offsets 33-34 "tag" 0x4141 = "AA", set by WMAA
#   PSSP  8 bit   offset 35     ← I/O PORT NUMBER TO TRIGGER SMI
#
# WSMI writes 0xD0 to the port whose address comes from PSSP. If the firmware did
# not fill PSSP, the write goes to port 0x0000 and the SMI handler is never
# called, and then the interface is dead no matter how much you write to it.
acpi_eval() {
  local path=$1 raw
  exec 9>"$LOCK"; flock 9
  echo "$path" > "$CALL" 2>/dev/null
  raw=$(tr -d '\0' < "$CALL")
  exec 9>&-
  echo "$raw"
}

diag() {
  hdr "MIFS TRANSPORT DIAGNOSTICS"
  local base='\_SB.PC00.WMID'

  # First any WMAA call: it sets MTID and CTID. If these fields
  # then read back, the write to NVS arrives and returns.
  echo "  Doing GET 0x10/02, then reading the service fields back."
  mifs 0xFA $CMD_CHARGE $SUB_LIMIT 0
  echo -n "    WMAA reply : "; out_hex
  echo

  local mtid ctid pssp wmib
  mtid=$(acpi_eval "$base.MTID")
  ctid=$(acpi_eval "$base.CTID")
  pssp=$(acpi_eval "$base.PSSP")
  wmib=$(acpi_eval "$base.WMIB")

  printf "    MTID : %s   (expect 0x1, the method id set by WSMI)\n" "$mtid"
  printf "    CTID : %s   (expect 0x4141, the tag set by WMAA)\n" "$ctid"
  printf "    PSSP : %s   (I/O port to trigger SMI)\n" "$pssp"
  echo "    WMIB : $wmib"
  echo

  echo "── Verdict ───────────────────────────────────────────"
  if [ "$ctid" = "0x4141" ]; then
    echo "  ✔ the write to shared memory arrives: CTID came back as 0x4141."
  else
    echo "  ✗ CTID came back as \"$ctid\", not 0x4141: the write to shared"
    echo "    memory does NOT arrive or the region is wrong. Then the whole interface"
    echo "    is broken for a reason that lies before any SMI."
  fi
  case "$pssp" in
    0x0|0x00|0)
      echo "  ✗ PSSP = 0. The SMI trigger port is not filled in by the firmware, so"
      echo "    WSMI writes 0xD0 to port 0x0000 and the handler is NOT CALLED."
      echo "    This explains the kernel driver's zeros: it honestly calls the method,"
      echo "    the method honestly puts the buffer in memory, and that is all."
      echo "    A charge limit cannot be set this way, the firmware needs fixing."
      ;;
    ''|Error*|'not called'*)
      echo "  ? PSSP was not read (\"$pssp\"): the field cannot be"
      echo "    evaluated, no verdict can be made from it."
      ;;
    *)
      echo "  ✔ PSSP = $pssp: the port is set, SMI can be triggered in principle."
      echo "    So the problem is not the transport, but the layout or the fact that"
      echo "    this particular firmware does not implement group 0x10."
      ;;
  esac
  echo "═══════════════════════════════════════════════════════"
}

# ── Rotation precompensation sweep ─────────────────────────────────────
# Established: response = request rotated left by 2 bytes, and this holds
# for any command, including a nonexistent one. So the buffer gets skewed
# mechanically, the SMI handler does not see what we sent.
#
# Hypothesis: the skew is symmetric, and if the request is rotated RIGHT by 2,
# the correct request lands in memory. Test with a sweep: send the same
# logical request rotated by 0…7 and see whether the response stops
# being a permutation of the request. If it does, the firmware finally answered.
#
# GET only: the buffer has 0xFA and never 0xFB, so no
# rotation can turn this into a write.
mifs_raw_buf() {
  # -n applies to EVERY name in the declaration, so the nameref is declared
  # on a separate line, otherwise i/str/out also become namerefs and bash fails
  local -n _b=$1
  local i str out
  str=""
  for i in "${!_b[@]}"; do str+=$(printf '0x%02x ' "${_b[$i]}"); done
  exec 9>"$LOCK"; flock 9
  echo "$WMAA 0x0 0x1 { $str}" > "$CALL" || die "write to $CALL failed"
  out=$(tr -d '\0' < "$CALL")
  exec 9>&-
  case "$out" in '{'*) ;; *) die "unexpected response: $out" ;; esac
  out=${out#\{}; out=${out%\}}; out=${out//,/ }
  OUT=()
  for i in $out; do OUT+=("$((i))"); done
}

rotsweep() {
  hdr "ROTATION PRECOMPENSATION SWEEP (GET only)"
  echo "  Logical request: 00 FA 00 10 02 00 00 00  (GET charge limit)"
  echo
  echo "  The observed rotation is the SUM of the write skew and the read skew."
  echo "  It is the write skew that must be compensated, and it can have any"
  echo "  sign, so the sweep covers all 32 positions, not eight."
  echo

  local n k s ok
  for n in $(seq "${1:-0}" "${2:-31}"); do
    # logical buffer
    local L=(0 0xFA 0 0x10 0x02 0 0 0)
    for k in $(seq 8 31); do L+=(0); done
    # rotate right by n: S[(i+n) mod 32] = L[i]
    local S=(); for k in $(seq 0 31); do S+=(0); done
    for k in $(seq 0 31); do S[$(( (k + n) % 32 ))]=$(( ${L[$k]} )); done

    mifs_raw_buf S

    # is the response a rotation of the request?
    local found=-1
    for s in $(seq 0 31); do
      ok=1
      for k in $(seq 0 31); do
        [ "${OUT[$k]:-0}" = "${S[$(( (k + s) % 32 ))]}" ] || { ok=0; break; }
      done
      [ "$ok" = 1 ] && { found=$s; break; }
    done

    if [ "$found" -ge 0 ]; then
      printf "  n=%-2d  echo, rotated left by %d\n" "$n" "$found"
    else
      printf "  n=%-2d  ★ NOT a permutation of the request: THE FIRMWARE ANSWERED\n" "$n"
      printf "        IN  "; for k in "${!S[@]}"; do printf '%02x ' "${S[$k]}"; done; echo
      printf "        OUT "; for k in "${!OUT[@]}"; do printf '%02x ' "${OUT[$k]}"; done; echo
      echo "        status bytes:"
      for k in "${!OUT[@]}"; do
        case "${OUT[$k]}" in
          128) printf "          [%d] = 0x80 supported\n" "$k" ;;
          224) printf "          [%d] = 0xE0 not supported\n" "$k" ;;
        esac
      done
    fi
  done
  echo "═══════════════════════════════════════════════════════"
}

# ── Does the CPU actually count SMI ────────────────────────────────────
# MSR 0x34 = MSR_SMI_COUNT, the counter of handled SMIs since power-on.
# In the msr driver the file offset is the register number, so read
# at offset 0x34 = 52 BYTES.
#
# ⚠ Only bs=8 count=1 iflag=skip_bytes. With bs=1 count=8 dd makes eight
#   one-byte reads, and msr_read rejects anything not a multiple of 8 bytes
#   (count % 8 → -EINVAL), and the request silently returns nothing.
#
# This is the only independent check that writing 0xD0 to port 0xB2
# reaches SMM at all. If the counter does not grow, the handler is not at fault:
# SMI is simply not generated, and no fiddling with the buffer will help.
read_smi_count() {
  local v
  v=$(dd if=/dev/cpu/0/msr bs=8 count=1 skip=52 iflag=skip_bytes 2>/dev/null \
      | od -An -tu8 | tr -d ' ')
  [ -n "$v" ] || return 1
  echo "$v"
}

smi_test() {
  hdr "SMI COUNTER (MSR 0x34)"

  [ -e /dev/cpu/0/msr ] || modprobe msr 2>/dev/null
  [ -e /dev/cpu/0/msr ] || die "no /dev/cpu/0/msr: the msr module did not load"

  local a b c d
  if ! a=$(read_smi_count); then
    echo "  Cannot read MSR 0x34. Check in order:"
    printf "    lockdown : %s  (a non-zero mode blocks MSR access)\n" \
      "$(cat /sys/kernel/security/lockdown 2>/dev/null || echo 'no file')"
    printf "    device    : %s\n" \
      "$([ -e /dev/cpu/0/msr ] && echo present || echo 'absent, modprobe msr')"
    die "MSR unavailable"
  fi
  printf "  before the call    : %s\n" "$a"

  # An idle pause of the same length: SMIs on this machine also happen by
  # themselves (thermals, EC), so a control is needed, not just "it grew".
  sleep 1
  b=$(read_smi_count) || die "cannot read MSR 0x34"
  printf "  after 1 s of idle  : %s   (background: +%d)\n" "$b" "$((b - a))"

  mifs 0xFA $CMD_CHARGE $SUB_LIMIT 0
  c=$(read_smi_count) || die "cannot read MSR 0x34"
  printf "  after the WMAA call: %s   (growth: +%d)\n" "$c" "$((c - b))"

  sleep 1
  d=$(read_smi_count) || die "cannot read MSR 0x34"
  printf "  another 1 s of idle: %s   (background: +%d)\n" "$d" "$((d - c))"

  echo
  echo "── Verdict ───────────────────────────────────────────"
  local bg=$((b - a)) call=$((c - b)) bg2=$((d - c))
  if [ "$call" -gt "$bg" ] && [ "$call" -gt "$bg2" ]; then
    echo "  ✔ the call gives an SMI above background: writing 0xD0 to port 0xB2 reaches"
    echo "    SMM, the handler is called. So it receives the request and"
    echo "    deliberately answers nothing: group 0x10 is not implemented"
    echo "    in this firmware."
  elif [ "$call" = 0 ]; then
    echo "  ✗ the call does NOT give a single SMI. Writing to port 0xB2 does not cause"
    echo "    an interrupt: the APMC SMI source is disabled in the chipset. Then"
    echo "    the interface is dead at a level below ACPI, and a custom SSDT will not help:"
    echo "    it would write to the same port."
  else
    echo "  ? growth $call with background $bg/$bg2: cannot be told from noise."
    echo "    Repeat at idle, preferably without load and on battery."
  fi
  echo "═══════════════════════════════════════════════════════"
}

# ── What REALLY lands in memory ────────────────────────────────────────
# The rotation sweep only tested the hypothesis "the write skew is a rotation".
# If it is another permutation, rotating the input was useless in principle.
# The region lies in ACPI NVS, which is not System RAM, so /dev/mem
# allows it even with STRICT_DEVMEM.
#
# Probe: send a buffer where byte i equals i (00 01 02 … 1f). Then the memory
# contents show the permutation directly, without brute force. It cannot
# become a write: the operation byte is 0x01, not 0xFB.
REGION=$((0x44A61000))
REGION_LEN=42

read_region() {
  dd if=/dev/mem bs=$REGION_LEN count=1 skip=$REGION iflag=skip_bytes 2>/dev/null \
    | od -An -tx1 -v | tr -s ' ' | sed 's/^ //'
}

memprobe() {
  hdr "WHAT REALLY LANDS IN MEMORY (reading /dev/mem)"
  echo "  Region XGNS: physical 0x44A61000, $REGION_LEN bytes, ACPI NVS."
  echo "  We write NOTHING: only a GET call and a memory read."
  echo

  local before after
  before=$(read_region)
  if [ -z "$before" ]; then
    echo "  ✗ cannot read /dev/mem at 0x44A61000."
    echo "    Probably IO_STRICT_DEVMEM=y and the region is held by a driver."
    echo "    Then only a custom SSDT with byte access remains."
    die "/dev/mem unavailable"
  fi
  echo "  before the call :"
  echo "$before" | sed 's/^/    /'
  echo

  # identity probe: byte i = i
  local P=() i
  for i in $(seq 0 31); do P+=( "$i" ); done
  mifs_raw_buf P
  echo "  sent      : 00 01 02 03 … 1f  (byte i = i)"
  printf "  returned  : "; out_hex

  after=$(read_region)
  echo "  in memory after the call :"
  echo "$after" | sed 's/^/    /'
  echo

  # analysis: region bytes 1..32 are the WMIB buffer
  local -a M=()
  for i in $after; do M+=( $((16#$i)) ); done
  echo "── Permutation on write ──────────────────────────────"
  local clean=1 rot="" k
  for i in $(seq 0 31); do
    [ "${M[$((i+1))]:-x}" = "$i" ] || clean=0
  done
  if [ "$clean" = 1 ]; then
    echo "  ✔ memory holds EXACTLY what was sent (byte i = i)."
    echo "    So the write is clean, and the rotation by 2 is entirely on the read."
    echo "    The handler saw correct requests all this time,"
    echo "    and did not answer a single one. Group 0x10 is not implemented."
  else
    # check whether it is a rotation
    for k in $(seq 0 31); do
      local ok=1
      for i in $(seq 0 31); do
        [ "${M[$((i+1))]:-x}" = "$(( (i + k) % 32 ))" ] || { ok=0; break; }
      done
      [ "$ok" = 1 ] && { rot=$k; break; }
    done
    if [ -n "$rot" ]; then
      printf "  the write rotates by %d. The sweep covered this.\n" "$rot"
    else
      echo "  ★ the write shuffles with something OTHER than a rotation: the sweep did not cover this."
      echo "    Showing the handler a correct request through the stock WMAA"
      echo "    is impossible in principle. Direct access is needed (direct)."
      printf "    map: "
      for i in $(seq 0 31); do printf "%d→%s " "$i" "${M[$((i+1))]}"; done; echo
    fi
  fi
  printf "  MTID(byte 0) = %s   CTID(bytes 33,34) = %s %s\n" \
    "${M[0]}" "${M[33]}" "${M[34]}"
  echo "═══════════════════════════════════════════════════════"
}

# ── Raw call ───────────────────────────────────────────────────────────
raw_call() {
  local op=${1:-0xFA} cmd=${2:-0x10} arg=${3:-0} val=${4:-0}
  case "$op" in 0xFB|0xfb|251) echo "  ⚠ this is a SET: it will be written to the firmware" >&2 ;; esac
  mifs "$op" "$cmd" "$arg" "$val"
  printf "  IN : 00 %02x 00 %02x %02x 00 %02x 00\n" "$((op))" "$((cmd))" "$((arg))" "$((val))"
  echo -n "  ── "; out_ruler
  echo -n "  OUT "; out_hex
}

# ── Argument parsing ───────────────────────────────────────────────────
case "${1:-status}" in
  status|'')
    show_status
    ;;
  probe)
    probe
    ;;
  calib)
    calib
    ;;
  diag)
    diag
    ;;
  rotsweep)
    rotsweep "${2:-0}" "${3:-31}"
    ;;
  smi)
    smi_test
    ;;
  mem)
    memprobe
    ;;
  raw)
    shift
    raw_call "$@"
    ;;
  set)
    pct=${2:-}
    [ -n "$pct" ] || die "specify a limit: $0 set 80   (40/50/60/70/80)"
    code=$(pct_to_code "$pct") \
      || die "limit $pct % is not in the firmware's set. Available: 40 50 60 70 80 (and 100 = remove). The firmware does not hold 90 %."
    hdr "SETTING THE LIMIT TO $pct %"
    apply "$code" "$pct"
    ;;
  off|100)
    hdr "REMOVING THE LIMIT"
    apply 0 100
    ;;
  *)
    die "unknown command \"$1\". Available: status, probe, set <%>, off"
    ;;
esac
