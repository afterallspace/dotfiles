#!/usr/bin/env bash
# Throwaway headless GNOME Shell for testing extensions without logging out.
# Own D-Bus session, dconf, data and runtime dirs; unsafe mode is switched on so
# Eval and Screenshot work. Nothing touches the real session.
#
#   sandbox.sh start [uuid,...] [seed.dconf] [WxH] [scale]   e.g. start panel-clock@afterall '' 3840x2400 2.5
#   sandbox.sh eval 'JS'                 run JS in the shell (Main is in scope), prints the result
#   sandbox.sh shot out.png [cursor]     screenshot, optionally with the pointer
#   sandbox.sh env CMD...                run a client inside (zenity, gsettings, gnome-extensions prefs)
#   sandbox.sh log                       the shell's output
#   sandbox.sh stop
set -euo pipefail

SRC="$(dirname "$(readlink -f "$0")")"
ROOT="${XDG_CACHE_HOME:-$HOME/.cache}/gnome-sandbox"
RUN="$ROOT/run"

bus() { cat "$RUN/bus"; }
inside() {
    env -i HOME="$HOME" PATH=/usr/bin XDG_RUNTIME_DIR="$RUN" WAYLAND_DISPLAY=wayland-sandbox \
        DBUS_SESSION_BUS_ADDRESS="$(bus)" XDG_CONFIG_HOME="$ROOT/config" XDG_DATA_HOME="$ROOT/data" "$@"
}
shell_call() { gdbus call --address "$(bus)" --dest org.gnome.Shell "$@"; }

stop() {
    local pid
    # Kill by recorded PID only: pkill -f would match this script's own command line.
    if pid="$(cat "$RUN/shell.pid" 2>/dev/null)" && [[ $(cat "/proc/$pid/comm" 2>/dev/null) == gnome-shell ]]; then
        kill "$pid"
        while [[ -d /proc/$pid ]]; do sleep 0.2; done
    fi
    # Services the private bus activated (portals, dconf, gvfs) outlive it otherwise.
    for pid in $(pgrep -u "$UID" || true); do
        grep -qz "^XDG_RUNTIME_DIR=$RUN\$" "/proc/$pid/environ" 2>/dev/null && kill "$pid" 2>/dev/null || true
    done
    rm -f "$RUN/shell.pid" "$RUN/bus"
}

start() {
    local exts="${1:-}" seed="${2:-}" size="${3:-1920x1200}" scale="${4:-}"
    stop
    rm -rf "$ROOT"
    mkdir -p "$ROOT"/{config,data/gnome-shell/extensions,cache,state} "$RUN"
    chmod 700 "$RUN"

    local dev="$ROOT/data/gnome-shell/extensions/sandbox-devtools@afterall"
    mkdir -p "$dev"
    printf '{"uuid": "sandbox-devtools@afterall", "name": "Sandbox devtools", "description": "Unsafe mode for the sandbox", "shell-version": ["51"]}\n' >"$dev/metadata.json"
    printf "import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js'\nexport default class Devtools extends Extension { enable() { global.context.unsafe_mode = true } disable() {} }\n" >"$dev/extension.js"

    local list='["sandbox-devtools@afterall"' uuid
    IFS=, read -ra uuids <<<"$exts"
    for uuid in "${uuids[@]}"; do
        [[ -n $uuid ]] || continue
        if [[ -d $SRC/$uuid ]]; then
            ln -s "$SRC/$uuid" "$ROOT/data/gnome-shell/extensions/$uuid"
        else
            ln -s "$HOME/.local/share/gnome-shell/extensions/$uuid" "$ROOT/data/gnome-shell/extensions/$uuid"
        fi
        list+=", \"$uuid\""
    done
    list+=']'

    XDG_CONFIG_HOME="$ROOT/config" XDG_DATA_HOME="$ROOT/data" XDG_CACHE_HOME="$ROOT/cache" \
        XDG_STATE_HOME="$ROOT/state" XDG_RUNTIME_DIR="$RUN" XDG_DATA_DIRS=/usr/local/share:/usr/share \
        LIST="$list" SEED="$seed" SIZE="$size" \
        setsid -f env -u WAYLAND_DISPLAY -u DISPLAY -u DBUS_SESSION_BUS_ADDRESS dbus-run-session -- bash -c '
            echo "$DBUS_SESSION_BUS_ADDRESS" >"$XDG_RUNTIME_DIR/bus"
            gsettings set org.gnome.shell enabled-extensions "$LIST"
            gsettings set org.gnome.shell welcome-dialog-last-shown-version 999
            [[ -n $SEED ]] && dconf load / <"$SEED"
            echo $$ >"$XDG_RUNTIME_DIR/shell.pid"
            exec gnome-shell --headless --wayland --no-x11 --virtual-monitor "$SIZE" --wayland-display wayland-sandbox
        ' >"$ROOT/shell.log" 2>&1

    local i
    for i in $(seq 60); do
        sleep 0.5
        [[ -s $RUN/bus ]] && shell_call --object-path /org/gnome/Shell --method org.freedesktop.DBus.Properties.Get \
            org.gnome.Shell ShellVersion >/dev/null 2>&1 && break
    done
    sleep 2
    if [[ -n $scale ]]; then
        gdbus call --address "$(bus)" --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig \
            --method org.gnome.Mutter.DisplayConfig.ApplyMonitorsConfig 2 1 \
            "[(0, 0, $scale, 0, true, [('Meta-0', '$size@60.000', @a{sv} {})])]" '@a{sv} {}' >/dev/null
        sleep 2
    fi
    shell_call --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'Main.overview.hide()' >/dev/null
    echo "sandbox up: $size${scale:+ @ $scale}, extensions: ${exts:-none}"
}

case "${1:-}" in
    start) shift; start "$@" ;;
    eval) shell_call --object-path /org/gnome/Shell --method org.gnome.Shell.Eval "$2" ;;
    shot) gdbus call --address "$(bus)" --dest org.gnome.Shell.Screenshot --object-path /org/gnome/Shell/Screenshot \
        --method org.gnome.Shell.Screenshot.Screenshot "${3:-false}" false "$(readlink -f "$2")" >/dev/null ;;
    env) shift; inside "$@" ;;
    log) cat "$ROOT/shell.log" ;;
    stop) stop ;;
    *) sed -n '2,12p' "$0"; exit 1 ;;
esac
