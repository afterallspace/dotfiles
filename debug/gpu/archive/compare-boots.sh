#!/usr/bin/env bash
# Compare the snapshots of a good and a bad boot saved by bootcheck.sh.
# Without arguments it takes the most recent snapshot of each kind.
#
#   ./compare-boots.sh
#   ./compare-boots.sh snapshots/GOOD_... snapshots/BAD_...
set -uo pipefail
cd "$(dirname "$0")"

G="${1:-$(ls -dt snapshots/GOOD_* 2>/dev/null | head -1)}"
B="${2:-$(ls -dt snapshots/BAD_*  2>/dev/null | head -1)}"

[ -n "$G" ] && [ -d "$G" ] || { echo "No snapshot of a good boot. Run ./bootcheck.sh after every reboot until you catch one."; exit 1; }
[ -n "$B" ] && [ -d "$B" ] || { echo "No snapshot of a bad boot."; exit 1; }

echo "═══════════════════════════════════════════════════════"
echo " GOOD: $(basename "$G")"
echo " BAD : $(basename "$B")"
echo "═══════════════════════════════════════════════════════"
echo
echo "── Verdicts ──────────────────────────────────────────"
paste -d'\n' <(sed 's/^/  G: /' "$G/verdict.txt") <(sed 's/^/  B: /' "$B/verdict.txt")

show_diff() {
  local name="$1" f="$2"
  echo
  echo "── $name ────────────────────────────────────────────"
  if [ -f "$G/$f" ] && [ -f "$B/$f" ]; then
    if diff -q "$G/$f" "$B/$f" >/dev/null 2>&1; then
      echo "  identical"
    else
      diff "$G/$f" "$B/$f" | sed 's/^</  G:/; s/^>/  B:/' | head -30
    fi
  else
    echo "  no data"
  fi
}

show_diff "nvidia driver parameters" nvidia-params.txt
show_diff "GPU power (RTD3 and others)" nvidia-power.txt
show_diff "mkinitcpio" mkinitcpio.txt
show_diff "modprobe.d" modprobe.d.txt

echo
echo "── Kernel log: lines absent from the other boot ──"
if [ -f "$G/kernel.log.gz" ] && [ -f "$B/kernel.log.gz" ]; then
  norm() { zcat "$1" | sed -E 's/^\[ *[0-9]+\.[0-9]+\] //; s/0x[0-9a-fA-F]+/0xADDR/g; s/\b[0-9]{4,}\b/NUM/g'; }
  echo "  ONLY IN GOOD:"
  comm -23 <(norm "$G/kernel.log.gz" | sort -u) <(norm "$B/kernel.log.gz" | sort -u) \
    | grep -viE "wlp0s20f3|UFW BLOCK|systemd-journald|Bluetooth|usb |audit" | head -20 | sed 's/^/    /'
  echo
  echo "  ONLY IN BAD:"
  comm -13 <(norm "$G/kernel.log.gz" | sort -u) <(norm "$B/kernel.log.gz" | sort -u) \
    | grep -viE "wlp0s20f3|UFW BLOCK|systemd-journald|Bluetooth|usb |audit" | head -20 | sed 's/^/    /'
else
  echo "  no journals in the snapshots"
fi

echo
echo "── Initialization timings ────────────────────────────"
for tag in "$G:GOOD" "$B:BAD"; do
  d="${tag%%:*}"; n="${tag##*:}"
  [ -f "$d/kernel.log.gz" ] || continue
  echo "  $n:"
  zcat "$d/kernel.log.gz" | grep -E "NVRM: loading|nvidia-modeset: Loading|nvidia-drm\] \[GPU ID|i915 .*Found alderlake" \
    | sed -E 's/(\[ *[0-9]+\.[0-9]+\]).*(NVRM: loading|nvidia-modeset|GPU ID|Found alderlake).*/    \1 \2/' | head -4
done
echo "═══════════════════════════════════════════════════════"
