#!/usr/bin/env bash
# Toggle screen recording via gpu-screen-recorder.
#
#   gsr-toggle          start / stop at native resolution
#   gsr-toggle 1080p    start / stop scaled down to 1080p height
set -euo pipefail

OUTDIR="$(xdg-user-dir VIDEOS 2>/dev/null || echo "$HOME/Videos")/Recordings"
RUNDIR="${XDG_RUNTIME_DIR:-/tmp}"
PIDFILE="$RUNDIR/gsr-toggle.pid"
FILEREF="$RUNDIR/gsr-toggle.file"
LOCKFILE="$RUNDIR/gsr-toggle.lock"
LOGFILE="$RUNDIR/gsr-toggle.log"
STARTFILE="$RUNDIR/gsr-toggle.start"
LAUNCHFILE="$RUNDIR/gsr-toggle.launch"

MIN_RUN_MS=1500

now_ms() { date +%s%3N; }

running_pid() {
    local pid
    [[ -s $PIDFILE ]] || return 1
    pid=$(<"$PIDFILE")
    [[ $pid =~ ^[0-9]+$ ]] || return 1
    [[ $(cat "/proc/$pid/comm" 2>/dev/null) == gpu-screen-reco ]] || return 1
    printf '%s' "$pid"
}

case ${1:-} in
    ""|1080p) ;;
    *) echo "usage: ${0##*/} [1080p]" >&2; exit 2 ;;
esac

exec 9>"$LOCKFILE"
flock 9

if pid=$(running_pid); then
    launched=0
    if [[ -s $LAUNCHFILE ]]; then
        launched=$(<"$LAUNCHFILE")
    fi
    if (( $(now_ms) - launched < MIN_RUN_MS )); then
        exit 0
    fi
    kill -INT "$pid"
    exit 0
fi

scale_args=()
if [[ ${1:-} == 1080p ]]; then
    scale_args=(-s 1920x1080)
fi

mkdir -p "$OUTDIR"
FILE="$OUTDIR/Screencast From $(date '+%Y-%m-%d %H-%M-%S').mp4"
printf '%s' "$FILE" >"$FILEREF"
printf '%s' "$(now_ms)" >"$LAUNCHFILE"
rm -f "$STARTFILE"

: >"$LOGFILE"

stdbuf -oL -eL gpu-screen-recorder \
    -w portal \
    -restore-portal-session yes \
    "${scale_args[@]}" \
    -f 60 \
    -q very_high \
    -k h264 \
    -ac aac \
    -a default_output \
    -cursor yes \
    -o "$FILE" </dev/null >"$LOGFILE" 2>&1 9>&- &

rec=$!
printf '%s' "$rec" >"$PIDFILE"

(
    while kill -0 "$rec" 2>/dev/null; do
        if grep -qE 'negotiation finished|update fps:' "$LOGFILE" 2>/dev/null; then
            printf '%s' "$(now_ms)" >"$STARTFILE"
            break
        fi
        sleep 0.1
    done

    stall=0 last_size=-1
    while kill -0 "$rec" 2>/dev/null; do
        sleep 2
        size=$(stat -c%s "$LOGFILE" 2>/dev/null || echo 0)
        if (( size == last_size )); then
            stall=$(( stall + 1 ))
        else
            stall=0
        fi
        last_size=$size

        if (( stall >= 5 )); then
            kill -INT "$rec" 2>/dev/null
            break
        fi
    done
) 9>&- &
watcher=$!

exec 9>&-
wait "$rec" || true
kill "$watcher" 2>/dev/null || true

captured=0
if [[ -s $STARTFILE ]]; then
    captured=1
fi

rm -f "$PIDFILE" "$STARTFILE" "$LAUNCHFILE"

if (( captured == 0 )); then
    rm -f "$FILE"
fi
