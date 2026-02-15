# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Removed brew shellenv calls as brew is not installed
export KUBECONFIG=/tmp/kubeconfig-certificate

# Created by `pipx` on 2025-11-23 18:37:10
export PATH="$PATH:/home/simon/.local/bin"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH=$PATH:$HOME/.local/opt/go/bin

# Alias for simon CLI to source and set environment variables
alias simon='source /home/simon/repos/simon-cli/simon'

# AI Agent configuration (used by 'simon ai')
export AI_AGENT='opencode'

# Converted aliases from Nushell config.nu
alias s='simon'
alias dev='simon dev'
alias plan='nvim /home/simon/repos/plan/Innan-1.md'
alias lg='lazygit'
alias n='nvim'
alias y='yazi'
alias d='dagger'
alias td='simon talos dashboard'
alias kd='simon kubernetes dashboard'
alias k='kubectl'
alias t='talosctl'
alias th='simon talos health'
alias thc='talosctl health --control-plane-nodes 10.10.10.11,10.10.10.12,10.10.10.13'
alias ai='simon ai'
alias ld='lazydocker'
alias cat='bat'
alias ut='simon talos update config'
alias config_talos='code $TALOSCONFIG'
alias config_kube='code $KUBECONFIG'

# Converted functions from Nushell config.nu
ll() {
    ls -l
}

e() {
    env | fzf
}

# Exempel för zsh/bash (kopiera från Yazi docs eller använd denna lite säkrare variant):
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if [ -f "$tmp" ]; then
        local cwd="$(cat -- "$tmp")"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && cd -- "$cwd"
        rm -f -- "$tmp"
    fi
}
