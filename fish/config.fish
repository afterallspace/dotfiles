source /usr/share/cachyos-fish-config/cachyos-config.fish

function fish_greeting
    if test "$TERM_PROGRAM" != vscode
        fastfetch
    end
end

if type -q starship
    starship init fish | source
end

set -gx PATH "$HOME/.local/share/fnm" $PATH
if type -q fnm
    fnm env --use-on-cd | source
end

set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
