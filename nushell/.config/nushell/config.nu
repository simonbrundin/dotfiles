# ~/.config/nushell/config.nu
# Minimal, snabb, och beroende av bootstrap

# ──────────────────────────────────────────────────────────────
# 1. Miljövariabler & repo-sökvägar
# ──────────────────────────────────────────────────────────────

$env.STARSHIP_CONFIG = $"($env.HOME)/.config/starship.toml"
$env.devenv-repo = "/home/simon/repos/devenv"
$env.dotfiles-path = $"($env.HOME)/repos/dotfiles"
$env.dot-nushell = $"($env.dotfiles-path)/nushell/.config/nushell/config.nu"
$env.dot-brew = $"($env.dotfiles-path)/brew/Brewfile"

# Omarchy
$env.OMARCHY_PATH = $"($env.HOME)/.local/share/omarchy" | path expand

# ──────────────────────────────────────────────────────────────
# 2. Nushell-inställningar
# ──────────────────────────────────────────────────────────────
$env.config = {
    show_banner: false
    edit_mode: "vi"
    cursor_shape: {
        vi_insert: "line"
        vi_normal: "block"
    }
    buffer_editor: "nvim"
}

$env.EDITOR = "nvim"

# ──────────────────────────────────────────────────────────────
# 3. PATH – smart och deduplicerad
# ──────────────────────────────────────────────────────────────
let custom_paths = [
    ($env.OMARCHY_PATH | path join "bin")
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/local/sbin"
    "/home/simon/bin"
    "/home/simon/.local/bin"
    "/usr/sbin"
    "/sbin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/home/linuxbrew/.linuxbrew/bin"
    "/home/simon/repos/simon-cli"
    "/home/simon/go/bin"
    "/home/simon/.cargo/bin"
    "/home/simon/.local/share/gem/ruby/3.4.0/bin"
]

$env.PATH = ($custom_paths | append $env.PATH | uniq)

# ──────────────────────────────────────────────────────────────
# 5. Alias
# ──────────────────────────────────────────────────────────────
alias s = simon
alias dev = simon dev
alias plan = nvim /home/simon/repos/plan/Innan-1.md
alias lg = lazygit
alias n = nvim
alias y = yazi
alias d = dagger
alias kd = simon kubernetes dashboard
alias k = ^kubectl
alias t = ^talosctl
alias th = simon talos health
alias thc = talosctl health --control-plane-nodes 10.10.10.11,10.10.10.12,10.10.10.13
alias ai = simon ai
alias ld = lazydocker
# alias docker = nerdctl
alias cat = ^bat
alias ut = simon talos update config
alias config_talos = ^code $env.TALOSCONFIG
alias config_kube = ^code $env.KUBECONFIG

# ──────────────────────────────────────────────────────────────
# 6. Funktioner
# ──────────────────────────────────────────────────────────────
def ll [] {
    ls -l | select name size modified mode target
}

# # Yazi med cd-efteråt
# def --env y [...args] {
#     let tmp = (mktemp -t "")
#     yazi ...$args --cwd-file $tmp
#     let cwd = (open $tmp)
#     if $cwd != "" and $cwd != $env.PWD {
#         cd $cwd
#     }
#     rm -fp $tmp
# }

def e [] {
    $env | fzf
}

# ──────────────────────────────────────────────────────────────
# 7. Externa init-filer
# ──────────────────────────────────────────────────────────────
source ~/.zoxide.nu
source ~/.config/nushell/vendor/autoload/starship.nu
# source $"($nu.cache-dir)/carapace.nu"
# source ~/.local/share/atuin/init.nu  # Aktivera när atuin är klar
