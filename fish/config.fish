if test "$TERM_PROGRAM" != "vscode"
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

set -gx PATH "$HOME/.local/share/fnm" $PATH
if type -q fnm
    fnm env --use-on-cd | source
end

if status is-interactive
    if test "$TERM_PROGRAM" != "vscode"
        cat ~/.cache/wal/sequences 2>/dev/null
    end
end

starship init fish | source

if status is-login
    if test (tty) = /dev/tty1
        for line in (gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
            set -gx (string split -m1 "=" -- $line)
        end
        clear
        exec start-hyprland > /dev/null 2>&1
    end
end

set -gx PNPM_HOME "/home/afterall/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end