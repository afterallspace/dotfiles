#!/usr/bin/env bash
# One-shot system cleanup: pacman cache, journal, trash, application caches.
#
#   cleanup.sh          clear everything that is safe to clear
#   cleanup.sh -n       dry run, delete nothing
#   cleanup.sh --deep   also caches that then have to be re-downloaded
#
# Deliberately untouched:
#   steamapps/compatdata  Proton prefixes, holding save games for titles with
#                         no cloud sync. Absent here in every mode.
#   btrfs balance         497 GB unallocated and data chunks 99.5% full —
#                         nothing to compact, only NVMe wear.
#   fstrim                mounted with discard=async and fstrim.timer enabled;
#                         a third pass by hand buys nothing.
set -uo pipefail

TRASH_AGE_DAYS=30    # trash entries older than this (0 = empty it outright)
COREDUMP_AGE_DAYS=7
JOURNAL_KEEP=200M
PACCACHE_KEEP=1      # past package versions kept; 1 is enough to roll back

TRASH="$HOME/.local/share/Trash"
DRY=0 DEEP=0

for a in "$@"; do case $a in
  -n|--dry-run) DRY=1 ;;
  --deep)       DEEP=1 ;;
  # This header is the help text; keep the range in sync when editing it.
  -h|--help)    sed -n '2,14p' "$0" | sed 's/^# \?//'; exit 0 ;;
  *)            echo "unknown argument: $a" >&2; exit 1 ;;
esac; done

human() { numfmt --to=iec-i --suffix=B --format='%.1f' "${1:-0}" 2>/dev/null || echo "${1}B"; }

# Allocated blocks, not apparent size: on btrfs with compression the two differ
# by a lot, and it is the blocks that come back. sudo, to reach under /var.
bytes() {
  local b=0
  [[ -e $1 ]] && b=$(sudo du -sB1 -- "$1" 2>/dev/null | cut -f1)
  echo "${b:-0}"
}

# "1.47 GiB" -> bytes. numfmt --from=iec understands "1.47G" but chokes on
# "GiB", which is exactly what paccache and pacman -Qi print.
iec2bytes() {
  awk '{ u = $2; sub(/iB$/, "", u); m = index("BKMGTP", substr(u, 1, 1))
         printf "%d\n", $1 * (1024 ^ (m - 1)) }' <<<"${1:-0 B}"
}

TOTAL=0
step()  { printf '\n\033[1m▸ %s\033[0m\n' "$1"; }
freed() { TOTAL=$(( TOTAL + ${1:-0} )); printf '   %s  %s\n' "$(human "${1:-0}")" "$2"; }
skip()  { printf '   \033[2m—        %s\033[0m\n' "$1"; }
run()   { (( DRY )) || "$@" >/dev/null 2>&1; }

# Measure a path, report it, remove it. Second argument overrides the label.
drop() {
  local b label
  b=$(bytes "$1")
  label="${2:-${1/#$HOME/\~}}"
  if (( b > 0 )); then freed "$b" "$label"; run rm -rf -- "$1"; else skip "$label: empty"; fi
}

# Same, but never while the owning process holds the files: a live Chromium has
# its cache mapped into memory and yanking it out from under the process
# takes tabs down with it.
drop_idle() {
  if pgrep -x "$1" >/dev/null 2>&1; then skip "$1 is running — skipped"; else drop "$2" "${3:-}"; fi
}

# Cache subdirectories inside a Chromium-family profile dir, removed only
# while the app is closed. One skip line per app, not per subdirectory.
drop_app() {
  local proc=$1 base=$2 d; shift 2
  if pgrep -x "$proc" >/dev/null 2>&1; then skip "$proc is running — skipped"; return; fi
  for d in "$@"; do drop "$base/$d"; done
}

printf '═══════════════════════════════════════════════════════\n'
if (( DRY )); then echo " CLEANUP — DRY RUN (nothing is deleted)"
else               echo " SYSTEM CLEANUP$( (( DEEP )) && echo ' — DEEP')"; fi
printf '═══════════════════════════════════════════════════════\n'

# Asked once up front rather than mid-run: some measurements read root-owned
# directories even on a dry run.
sudo -v || { echo "sudo required" >&2; exit 1; }
AVAIL_BEFORE=$(df --output=avail -B1 / | tail -1)

# ── pacman cache ────────────────────────────────────────────────────────
step "Pacman cache (/var/cache/pacman/pkg)"

# Parses "==> finished dry run: 77 candidates (disk space saved: 1.47 GiB)"
# into "<count> <size>". One paccache pass per question: over a thousand
# packages it is not free.
paccache_est() {
  paccache -d "$@" 2>/dev/null |
    awk -F'saved: ' '/candidates/ { split($2, a, ")"); split($0, c, " "); print c[5], a[1] }' | tail -1
}

for pass in "-k$PACCACHE_KEEP:superseded versions:-rk$PACCACHE_KEEP" \
            "-uk0:packages no longer installed:-ruk0"; do
  IFS=: read -r probe label apply <<<"$pass"
  est=$(paccache_est "$probe"); n=${est%% *}
  if [[ ${n:-0} -gt 0 ]]; then
    freed "$(iec2bytes "${est#* }")" "$label ($n)"
    # shellcheck disable=SC2086
    run sudo paccache $apply
  else
    skip "no $label"
  fi
done

# ── orphaned packages ───────────────────────────────────────────────────
step "Orphaned packages"
# Pulled in as dependencies of something since removed. Anything still needed
# for an AUR build gets reinstalled by paru on demand.
mapfile -t orphans < <(pacman -Qtdq 2>/dev/null)
if (( ${#orphans[@]} )); then
  # "Installed Size  : 24,66 MiB" — value and unit are the last two fields.
  # A comma decimal separator from the locale would be silently truncated by
  # awk, so normalise it first.
  osize=$(pacman -Qi "${orphans[@]}" 2>/dev/null | awk '
    /^Installed Size/ { v = $(NF-1); u = $NF; gsub(/,/, ".", v)
                        sub(/iB$/, "", u); m = index("BKMGTP", substr(u, 1, 1))
                        s += v * (1024 ^ (m - 1)) }
    END { printf "%d\n", s + 0 }')
  freed "${osize:-0}" "${orphans[*]}"
  run sudo pacman -Rns --noconfirm "${orphans[@]}"
else
  skip "none"
fi

# ── systemd journal ─────────────────────────────────────────────────────
step "Systemd journal"
jb=$(bytes /var/log/journal) jkeep=$(numfmt --from=iec "$JOURNAL_KEEP")
if (( jb > jkeep )); then
  freed "$(( jb - jkeep ))" "vacuum down to $JOURNAL_KEEP"
  run sudo journalctl --vacuum-size="$JOURNAL_KEEP"
else
  skip "already under $JOURNAL_KEEP"
fi

# ── core dumps ──────────────────────────────────────────────────────────
step "Core dumps"
cb=$(sudo find /var/lib/systemd/coredump -type f -mtime +$COREDUMP_AGE_DAYS -printf '%b\n' 2>/dev/null |
     awk '{ s += $1 * 512 } END { printf "%d\n", s + 0 }')
if (( cb > 0 )); then
  freed "$cb" "older than $COREDUMP_AGE_DAYS days"
  run sudo find /var/lib/systemd/coredump -type f -mtime +$COREDUMP_AGE_DAYS -delete
else
  skip "nothing old enough"
fi

# ── trash ───────────────────────────────────────────────────────────────
step "Trash"
# Age comes off the .trashinfo file, not the trashed file itself: a file's
# mtime is when it was last edited, not when it was thrown out, so a document
# written a year ago and binned today would be shredded immediately.
tb=0 items=0
if [[ -d $TRASH/info ]]; then
  age=(); (( TRASH_AGE_DAYS > 0 )) && age=(-mtime "+$TRASH_AGE_DAYS")
  items=$(find "$TRASH/info" -maxdepth 1 -name '*.trashinfo' 2>/dev/null | wc -l)
  while IFS= read -r -d '' info; do
    target="$TRASH/files/$(basename "$info" .trashinfo)"
    [[ -e $target ]] || continue
    tb=$(( tb + $(du -sB1 -- "$target" 2>/dev/null | cut -f1) ))
    (( DRY )) || { rm -rf -- "$target"; rm -f -- "$info"; }
  done < <(find "$TRASH/info" -maxdepth 1 -name '*.trashinfo' "${age[@]}" -print0 2>/dev/null)
fi
eb=$(bytes "$TRASH/expunged")   # leftovers from the trash's own failed deletes
if (( tb + eb > 0 )); then
  freed "$(( tb + eb ))" "$( (( TRASH_AGE_DAYS > 0 )) && echo "binned over $TRASH_AGE_DAYS days ago" || echo 'everything')"
  run rm -rf -- "$TRASH/expunged"
elif (( items > 0 )); then
  # Distinct from empty, and worth saying: otherwise it looks like the script
  # cannot see what Nautilus plainly shows.
  skip "$items item(s), all newer than $TRASH_AGE_DAYS days — left alone"
else
  skip "empty"
fi

# ── user caches ─────────────────────────────────────────────────────────
step "Thumbnails";  drop "$HOME/.cache/thumbnails"
step "Brave cache"; drop_idle brave "$HOME/.cache/BraveSoftware"
step "AUR build clones"; drop "$HOME/.cache/paru/clone"

# Electron apps keep caches inside the profile dir, not ~/.cache. VSIXs are
# downloaded extension archives VS Code keeps around after install.
step "VS Code caches"
drop_app code "$HOME/.config/Code" Cache "Code Cache" GPUCache CachedData CachedExtensionVSIXs
step "Claude Desktop caches"
drop_app claude-desktop "$HOME/.config/Claude" Cache "Code Cache" GPUCache
step "Discord caches"
drop_app Discord "$HOME/.config/discord" Cache "Code Cache" GPUCache

# Chrome-for-testing profiles arrive via Playwright/npx; their cache dirs
# regrow on the next test run. The browser binaries themselves
# (~/.cache/ms-playwright) are a re-download and stay in the deep pass.
step "Chrome-for-testing caches"
drop "$HOME/.cache/google-chrome-for-testing"
drop "$HOME/.cache/google-chrome-for-testing-headless"

# The active pnpm store is ~/.local/share/pnpm/store (pnpm store path);
# ~/.cache/pnpm is a leftover store from an older pnpm plus the dlx cache —
# content-addressed, worst case is a re-download.
step "Stale pnpm store"; drop "$HOME/.cache/pnpm"

step "npm / pnpm caches"
# Both arrive via fnm, which only puts them on PATH in an interactive shell.
# Under systemd or cron they are simply absent, and that is not an error.
if command -v pnpm >/dev/null 2>&1; then
  pb=$(bytes "$HOME/.local/share/pnpm/store")
  if (( DRY )); then
    skip "pnpm store prune (size not knowable up front, store is $(human "$pb"))"
  else
    pnpm store prune >/dev/null 2>&1
    freed "$(( pb - $(bytes "$HOME/.local/share/pnpm/store") ))" "pnpm store prune"
  fi
else
  skip "pnpm not on PATH"
fi
if command -v npm >/dev/null 2>&1; then
  nb=$(bytes "$HOME/.npm/_cacache")
  if (( nb > 0 )); then freed "$nb" "~/.npm/_cacache"; run npm cache clean --force
  else skip "npm cache empty"; fi
else
  skip "npm not on PATH"
fi

# ── deep pass ───────────────────────────────────────────────────────────
if (( DEEP )); then
  printf '\n───────────────────────────────────────────────────────\n'
  printf ' DEEP PASS — everything below has to be fetched again\n'
  printf '───────────────────────────────────────────────────────\n'

  # Not save games; those live in compatdata, which stays. These are shaders
  # compiled for the current driver. They rebuild on their own, at the cost of
  # stutter in the first minutes of each game.
  step "Steam shader cache"; drop "$HOME/.local/share/Steam/steamapps/shadercache"
  step "Playwright browsers"; drop "$HOME/.cache/ms-playwright" "~/.cache/ms-playwright (then: npx playwright install)"
  step "Spotify cache"; drop_idle spotify "$HOME/.cache/spotify"

  # Desktop GL/Vulkan shader caches, same trade as Steam's: rebuilt on the
  # fly, first minutes after wiping are slightly stuttery.
  step "Driver shader caches"
  drop "$HOME/.cache/mesa_shader_cache"
  drop "$HOME/.cache/mesa_shader_cache_db"
  drop "$HOME/.cache/nvidia"

  # tsserver re-fetches @types on demand; ~/.cache/node is node-gyp headers.
  step "Toolchain caches"
  drop "$HOME/.cache/typescript"
  drop "$HOME/.cache/node"
fi

# ── summary ─────────────────────────────────────────────────────────────
printf '\n═══════════════════════════════════════════════════════\n'
if (( DRY )); then
  printf ' Would free roughly: \033[1m%s\033[0m\n Run without -n to delete.\n' "$(human "$TOTAL")"
else
  printf ' Freed per df: \033[1m%s\033[0m\n Free on /: %s\n' \
    "$(human "$(( $(df --output=avail -B1 / | tail -1) - AVAIL_BEFORE ))")" \
    "$(df -h --output=avail / | tail -1 | tr -d ' ')"
fi
printf '═══════════════════════════════════════════════════════\n'

# For the record: 73% of this disk is Steam (1016 GB) and ~/Videos/Archive
# (217 GB). No amount of cache clearing competes with that — this script deals
# in single-digit gigabytes. Horizon Zero Dawn and its Remaster are both
# installed, 181 GB between them.
