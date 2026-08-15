#!/usr/bin/env bash
# One-shot health report: memory, disk, services, journal, packages, power.
#
#   sysreport.sh          quick report, no network, no root required
#   sysreport.sh --full   also: pending updates (network) and NVMe SMART (sudo)
#
# Root-only readings (SMART) degrade to a note instead of failing; the point
# is a report that always completes. Companion to cleanup.sh: this one only
# reads, that one only deletes.
set -uo pipefail

FULL=0
for a in "$@"; do case $a in
  --full)    FULL=1 ;;
  -h|--help) sed -n '2,9p' "$0" | sed 's/^# \?//'; exit 0 ;;
  *)         echo "unknown argument: $a" >&2; exit 1 ;;
esac; done

WARN=0
step() { printf '\n\033[1m▸ %s\033[0m\n' "$1"; }
say()  { printf '   %-22s %s\n' "$1" "$2"; }
warn() { WARN=$((WARN+1)); printf '   \033[33m⚠ %s\033[0m\n' "$1"; }
ok()   { printf '   ✔ %s\n' "$1"; }

printf '═══════════════════════════════════════════════════════\n'
printf ' SYSTEM REPORT — %s\n' "$(date '+%Y-%m-%d %H:%M')"
printf '═══════════════════════════════════════════════════════\n'
say "kernel"  "$(uname -r)"
say "uptime"  "$(uptime -p | sed 's/^up //')"
say "booted"  "$(uptime -s)"

# ── memory ──────────────────────────────────────────────────────────────
step "Memory"
read -r _ mt mu _ _ _ ma < <(free -m | awk '/^Mem:/')
read -r _ st su _ < <(free -m | awk '/^Swap:/')
say "RAM"  "$((mu/1024)).$(( (mu%1024)*10/1024 )) / $((mt/1024)) GiB used, $((ma*100/mt))% available"
if (( st > 0 )); then
  sp=$((su*100/st))
  say "swap" "${su} / ${st} MiB used (${sp}%)"
  (( sp >= 80 )) && warn "swap ${sp}% full — this is how the OOM kills started"
else
  warn "no swap configured at all"
fi
zramctl --output NAME,ALGORITHM,DISKSIZE,DATA,COMPR --noheadings 2>/dev/null |
  while read -r l; do say "zram" "$l"; done
# PSI: share of the last minute someone was stalled waiting for memory.
psi=$(awk -F'[= ]' '/^some/{print $3}' /proc/pressure/memory 2>/dev/null)
say "pressure(avg10)" "${psi:-?}%"
awk -v p="${psi:-0}" 'BEGIN{exit !(p+0 > 10)}' && warn "memory pressure ${psi}% — reclaim is hurting right now"
printf '   top consumers:\n'
ps -eo rss,comm --sort=-rss | awk 'NR>1 && NR<=6 {printf "     %6.0f MiB  %s\n", $1/1024, $2}'

# ── disk ────────────────────────────────────────────────────────────────
step "Disk"
read -r _ dsz dus dav dpc _ < <(df -h / | tail -1)
say "/ (btrfs)" "$dus used / $dsz, $dav free ($dpc)"
(( ${dpc%\%} >= 90 )) && warn "root filesystem ${dpc} full"
nvt=$(cat /sys/class/nvme/nvme0/hwmon*/temp1_input 2>/dev/null | head -1)
[ -n "${nvt:-}" ] && say "NVMe temp" "$((nvt/1000)) °C"
if (( FULL )); then
  if sudo -n true 2>/dev/null; then
    sudo -n smartctl -H -A /dev/nvme0n1 2>/dev/null | awk -F': *' '
      /overall-health/ { print "   SMART: " $2 }
      /Percentage Used|Available Spare:|Media and Data Int/ { printf "   %-22s %s\n", $1":", $2 }'
  else
    say "SMART" "needs cached sudo: run 'sudo -v' first, then --full"
  fi
fi

# ── power ───────────────────────────────────────────────────────────────
step "Power"
B=/sys/class/power_supply/BAT0
if [ -d "$B" ]; then
  ef=$(cat $B/energy_full) ed=$(cat $B/energy_full_design)
  say "battery" "$(cat $B/capacity)% ($(cat $B/status)), wear $(( (ed-ef)*100/ed ))% of design"
fi
say "AC adapter" "$([ "$(cat /sys/class/power_supply/ADP1/online 2>/dev/null)" = 1 ] && echo plugged || echo unplugged)"
say "profile" "$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo '?')"
# dGPU state via sysfs only: nvidia-smi would wake the card from D3cold.
say "dGPU" "$(cat /sys/bus/pci/devices/0000:01:00.0/power_state 2>/dev/null || echo '?'), runtime $(cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status 2>/dev/null || echo '?')"
pkg=$(sensors 2>/dev/null | awk '/^Package id 0/{gsub(/[+°C]/,"",$4); print $4; exit}')
[ -n "${pkg:-}" ] && say "CPU package" "${pkg} °C"
# Last verdict of the session GPU unlock (see debug/gpu/OPERATIONS.md).
gu=$(journalctl --user -u nvpcf-unlock.service -b 0 --no-pager 2>/dev/null | grep -E "OK:|FAIL:" | tail -1 | sed 's/.*: //')
[ -n "${gu:-}" ] && say "GPU unlock" "$gu"

# ── services ────────────────────────────────────────────────────────────
step "Services"
sf=$(systemctl --failed --no-legend --plain 2>/dev/null | awk '{print $1}')
uf=$(systemctl --user --failed --no-legend --plain 2>/dev/null | awk '{print $1}')
if [ -n "$sf$uf" ]; then
  for u in $sf $uf; do warn "failed: $u"; done
else
  ok "no failed units (system + user)"
fi
say "running services" "$(systemctl list-units --type=service --state=running --no-legend --plain | wc -l) system, $(systemctl --user list-units --type=service --state=running --no-legend --plain | wc -l) user"
systemctl list-units --type=service --state=running --no-legend --plain |
  awk '{print $1}' | sed 's/\.service$//' | sort | tr '\n' ' ' | fold -s -w 52 | sed 's/^/     /'
echo

# ── journal ─────────────────────────────────────────────────────────────
step "Journal (this boot)"
say "disk usage" "$(journalctl --disk-usage 2>/dev/null | grep -oE '[0-9.]+[KMG]' | head -1)"
# Digest of kernel errors, minus noise this machine is known to produce
# (see debug/): SMBus busy, TDX, MOK cert. Anything else deserves eyes.
BENIGN='SMBus is busy|TDX not supported|X\.509 certificate -65|^\s*$'
kerr=$(journalctl -k -b 0 -p err --no-pager 2>/dev/null | sed -E 's/^[A-Za-z]+ [0-9]+ [0-9:]+ \S+ kernel: ?//' | grep -vE "$BENIGN" | sort | uniq -c | sort -rn)
if [ -n "$kerr" ]; then
  printf '   kernel errors (deduplicated):\n'; echo "$kerr" | head -8 | sed 's/^/     /'
else
  ok "no unexpected kernel errors"
fi
ooms=$(journalctl -b 0 --no-pager 2>/dev/null | grep -c "Out of memory: Killed")
if (( ooms > 0 )); then warn "$ooms OOM kill(s) this boot — check swap above"; else ok "no OOM kills"; fi

# ── packages ────────────────────────────────────────────────────────────
step "Packages"
say "installed" "$(pacman -Qq | wc -l) total, $(pacman -Qeq | wc -l) explicit, $(pacman -Qmq | wc -l) AUR"
orph=$(pacman -Qtdq 2>/dev/null)
if [ -n "$orph" ]; then warn "orphans: $(echo "$orph" | tr '\n' ' ')"; else ok "no orphans"; fi
# du exits non-zero on unreadable root-owned entries, and pipefail would
# propagate that even though the total printed fine — hence no || fallback.
pc=$(du -sh /var/cache/pacman/pkg 2>/dev/null | cut -f1); say "pacman cache" "${pc:-?}"
if (( FULL )) && command -v checkupdates >/dev/null; then
  n=$(checkupdates 2>/dev/null | wc -l)
  say "pending updates" "$n"
fi

# ── summary ─────────────────────────────────────────────────────────────
printf '\n═══════════════════════════════════════════════════════\n'
if (( WARN )); then printf ' \033[33m%d warning(s) above.\033[0m\n' "$WARN"
else printf ' \033[1mAll clear.\033[0m\n'; fi
printf '═══════════════════════════════════════════════════════\n'
