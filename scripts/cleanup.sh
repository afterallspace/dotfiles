#!/usr/bin/env bash
# One-shot system cleanup: orphans, pacman cache, journal, trash, app caches.
# One run is enough: what it reports is gone, and a second run right after finds
# only what running apps wrote in between.
#
#   cleanup.sh       clear everything that is safe to clear
#   cleanup.sh -n    dry run, delete nothing
#
# Deliberately untouched:
#   steamapps/compatdata  Proton prefixes, holding save games for titles with
#                         no cloud sync.
#   steamapps/shadercache Wiped by hand it does not come back: Steam trusts
#                         CommittedDepotManifests in config/config.vdf and never
#                         re-downloads the pre-cache, so every shader then
#                         compiles in-game. It also holds Proton's video
#                         transcodes, gigabytes per title. A clean rebuild: Steam
#                         closed, shader subdirs removed, their segments cut from
#                         CommittedDepotManifests.
#   rebuildable caches    Driver shaders, Playwright browsers, Spotify, tsserver
#                         types, ~/.cache/node (corepack's pnpm, node-gyp headers).
#                         Wiping them only buys stutter and downloads.
#   btrfs balance         497 GB unallocated and data chunks 99.5% full —
#                         nothing to compact, only NVMe wear.
#   fstrim                mounted with discard=async and fstrim.timer enabled;
#                         a third pass by hand buys nothing.
set -uo pipefail

TRASH_AGE_DAYS=30    # trash entries older than this (0 = empty it outright)
COREDUMP_AGE_DAYS=7
THUMBNAIL_AGE_DAYS=30
PNPM_STALE_DAYS=30   # an old store generation untouched this long is dead
JOURNAL_KEEP=200M
PACCACHE_KEEP=2      # versions kept per package: installed + one to roll back to

TRASH="$HOME/.local/share/Trash"
DRY=0

for a in "$@"; do case $a in
  -n|--dry-run) DRY=1 ;;
  -h|--help)    awk 'NR > 1 { if (!/^#/) exit; sub(/^# ?/, ""); print }' "$0"; exit 0 ;;
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

# Sums find's %b (512-byte blocks) from stdin into bytes.
blocks() { awk '{ s += $1 * 512 } END { printf "%d\n", s + 0 }'; }

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

# Measure a path, remove it, report what actually went. Whatever rm could not
# take is said out loud instead of being counted as freed and found again by
# the next run.
drop() {
  local b left=0 label
  b=$(bytes "$1")
  label="${2:-${1/#$HOME/\~}}"
  if (( b == 0 )); then skip "$label: empty"; return; fi
  run rm -rf -- "$1"
  (( DRY )) || left=$(bytes "$1")
  if (( b > left )); then freed "$(( b - left ))" "$label"; fi
  if (( left > 0 )); then skip "$label: $(human "$left") could not be removed"; fi
}

# Files under a directory older than N days.
drop_old() {
  local dir=$1 days=$2 b
  b=$(sudo find "$dir" -type f -mtime "+$days" -printf '%b\n' 2>/dev/null | blocks)
  if (( b > 0 )); then
    freed "$b" "older than $days days"
    run sudo find "$dir" -type f -mtime "+$days" -delete
  else
    skip "nothing old enough"
  fi
}

# Same as drop, but never while the owning process holds the files: a live
# Chromium has its cache mapped into memory and yanking it out from under the
# process takes tabs down with it.
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
else               echo " SYSTEM CLEANUP"; fi
printf '═══════════════════════════════════════════════════════\n'

# Asked once up front rather than mid-run: some measurements read root-owned
# directories even on a dry run.
sudo -v || { echo "sudo required" >&2; exit 1; }
AVAIL_BEFORE=$(df --output=avail -B1 / | tail -1)

# ── orphaned packages ───────────────────────────────────────────────────
# Before the pacman cache: what goes here becomes "no longer installed", and
# only then can the cache pass below take its packages in the same run.
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

# ── systemd journal ─────────────────────────────────────────────────────
step "Systemd journal"
# Vacuuming only ever removes archived files, so those are what gets compared
# with the limit. Against the whole directory, active files included, a journal
# slightly over it promised the same megabytes on every run and freed none.
ab=$(sudo find /var/log/journal -type f -name '*@*' -printf '%b\n' 2>/dev/null | blocks)
jkeep=$(numfmt --from=iec "$JOURNAL_KEEP")
if (( ab > jkeep )); then
  freed "$(( ab - jkeep ))" "archived logs, down to $JOURNAL_KEEP"
  run sudo journalctl --vacuum-size="$JOURNAL_KEEP"
else
  skip "archived logs already under $JOURNAL_KEEP"
fi

# ── core dumps ──────────────────────────────────────────────────────────
step "Core dumps"
drop_old /var/lib/systemd/coredump "$COREDUMP_AGE_DAYS"

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
# Age, not a wipe: what is in use regrows as soon as Nautilus opens the folder,
# and all a wipe buys is rendering it again.
step "Thumbnails"; drop_old "$HOME/.cache/thumbnails" "$THUMBNAIL_AGE_DAYS"
step "Brave cache"; drop_idle brave "$HOME/.cache/BraveSoftware"
step "AUR build clones"; drop "$HOME/.cache/paru/clone"

# Electron apps keep caches inside the profile dir, not ~/.cache. VSIXs are
# downloaded extension archives VS Code keeps around after install.
step "VS Code caches"
drop_app code "$HOME/.config/Code" Cache "Code Cache" GPUCache CachedData CachedExtensionVSIXs
step "Claude Desktop caches"
drop_app claude-desktop "$HOME/.config/Claude" Cache "Code Cache" GPUCache

# Chrome-for-testing profiles arrive via Playwright/npx; their cache dirs
# regrow on the next test run. The browser binaries themselves
# (~/.cache/ms-playwright) are a re-download and stay.
step "Chrome-for-testing caches"
drop "$HOME/.cache/google-chrome-for-testing"
drop "$HOME/.cache/google-chrome-for-testing-headless"

# Both tools arrive via fnm, which only puts them on PATH in an interactive
# shell. Under systemd or cron they are simply absent, and that is not an error.
#
# pnpm here is a corepack shim, and on a version bump corepack asks
# "about to download ... [Y/n]" on the terminal. With output captured that
# prompt is invisible and the script hangs on stdin — so: no prompt, no stdin.
node_tool() { COREPACK_ENABLE_DOWNLOAD_PROMPT=0 "$@" </dev/null 2>/dev/null; }

# Left by older pnpm versions, and prune only ever looks at the active store:
# ~/.cache/pnpm, and store generations (store/v10, ...) no project links into
# any more. No hard links and nothing recent, or the generation stays: a project
# pinned to another pnpm may still be using it.
step "Stale pnpm stores"
drop "$HOME/.cache/pnpm"
active=""
command -v pnpm >/dev/null 2>&1 && active=$(node_tool pnpm store path | tail -1)
if [[ $active =~ /store/v[0-9]+$ && -d $active ]]; then
  for d in "${active%/*}"/v*; do
    [[ -d $d && $d != "$active" ]] || continue
    if [[ -z $(find "$d" -type f \( -links +1 -o -mtime -"$PNPM_STALE_DAYS" \) -print -quit 2>/dev/null) ]]; then
      drop "$d"
    else
      skip "${d##*/}: still in use — left alone"
    fi
  done
fi

step "npm / pnpm caches"
if command -v pnpm >/dev/null 2>&1; then
  # Prune says what it removed, so nothing has to walk the store with du: at
  # about 240k files that is what stalled this step on a cold disk cache. It is
  # all df's business in the summary anyway.
  if (( DRY )); then
    skip "pnpm store prune (what it frees is known only after the run)"
  else
    pruned=$(node_tool pnpm store prune | grep -m1 '^Removed .*file')
    case $pruned in
      ""|"Removed 0 files"*) skip "pnpm store: nothing to prune" ;;
      *)                     printf '   %s from the pnpm store\n' "$pruned" ;;
    esac
  fi
else
  skip "pnpm not on PATH"
fi
if command -v npm >/dev/null 2>&1; then
  nb=$(bytes "$HOME/.npm/_cacache")
  if (( nb > 0 )); then freed "$nb" "~/.npm/_cacache"; run node_tool npm cache clean --force
  else skip "npm cache empty"; fi
else
  skip "npm not on PATH"
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
