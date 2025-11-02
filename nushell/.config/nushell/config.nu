# Developer Environment Repo
$env.devenv-repo = "/home/simon/repos/devenv"
# Dotfiles
$env.dotfiles-path = $"($env.HOME)/repos/dotfiles"
$env.dot-nushell = $"($env.dotfiles-path)/nushell/.config/nushell/config.nu"
$env.dot-brew = $"($env.dotfiles-path)/brew/Brewfile"
$env.config.show_banner = false



$env.config = {
  edit_mode: "vi"
  cursor_shape: {
    vi_insert: "line"    # Vertikalt streck i insert mode
    vi_normal: "block"   # Block i normal mode
  }
}

# Sätt Omarchy-variabler
$env.OMARCHY_PATH = $"~/.local/share/omarchy" | path expand

# Uppdatera PATH
$env.PATH = [
    ($env.OMARCHY_PATH | path join "bin")
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/local/sbin"
    "/home/simon/bin"
    "/usr/sbin"
    "/sbin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/home/linuxbrew/.linuxbrew/bin"
    "/home/simon/repos/simon-cli"
    "/home/simon/.cargo/bin"
    ...$env.PATH
]

# $env.XDG_CONFIG_HOME = "/home/simon/repos/dotfiles"
# Nvim som default editor
$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"

# Set up Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
source $"($nu.data-dir)/vendor/autoload/starship.nu"
$env.STARSHIP_CONFIG = '/home/simon/.config/starship.toml'
#alias config_starship = ^code $env.STARSHIP_CONFIG

# ENV Variables


alias s = simon
alias dev = simon dev
alias plan = nvim /home/simon/repos/plan/Innan-1.md
alias lg = lazygit
alias n = nvim
alias y = yazi
alias d = dagger
alias td = simon talos dashboard
alias kd = simon kubernetes dashboard
alias k = ^kubectl
alias t = ^talosctl
# Se hälsan för alla Talos-noder
alias th = simon talos health
alias thc = talosctl health --control-plane-nodes 10.10.10.11,10.10.10.12,10.10.10.13
alias ai = simon ai
alias docker = nerdctl 
alias cat = ^bat
# Uppdatera konfiguration i Talos-noder
alias ut = simon talos update config 
alias config_talos = ^code $env.TALOSCONFIG
alias config_kube = ^code $env.KUBECONFIG


def ll [] {
    ls -l | select name size modified mode target
}

source ~/.zoxide.nu


# Yazi - Flyttar till rätt katalog efter att ha kört yazi
def --env y [...args] {
	let tmp = (mktemp -t "")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

source $"($nu.cache-dir)/carapace.nu"
# source ~/.local/share/atuin/init.nu

# Kör DevPod CLI via bash-login-shell
# def devpod [...args] {
#   with-env { SHELL: "/bin/bash" } {
#     # -l för login-shell så PATH initieras korrekt
#     bash -lc $"devpod ($args | str join ' ')"
#   }
# }
