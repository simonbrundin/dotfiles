# Developer Environment Repo
$env.devenv-repo = "/Users/simon/repos/devenv"
# Dotfiles
$env.dotfiles-path = $"($env.devenv-repo)/.config"
$env.dot-nushell = $"($env.dotfiles-path)/nushell/https://www.youtube.com/watch?v=3szpSiGjBkQconfig.nu"
$env.dot-brew = $"($env.dotfiles-path)/brew/Brewfile"
$env.dot-karabiner = $"($env.dotfiles-path)/karabiner/karabiner.ts"
$env.dot-aerospace = $"($env.dotfiles-path)/aerospace/aerospace.toml"
$env.dot-devbox = $"($env.devenv-repo)/devbox.json" 
$env.config.show_banner = false



$env.config = {
  edit_mode: "vi"
  cursor_shape: {
    vi_insert: "line"    # Vertikalt streck i insert mode
    vi_normal: "block"   # Block i normal mode
  }
}

# Path-tillägg
$env.PATH = [
    "/nix/var/nix/profiles/default/bin"
    "/Users/simon/.local/share/devbox/global/default/.devbox/nix/profile/default/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/Users/simon/repos/simon-cli"
    "/usr/local/bin"
    "/usr/bin"
    "/usr/sbin"
    "/bin"
    "/sbin"
    "/Users/simon/go/bin"
    "/Users/simon/.bun/bin"
    "/Users/simon/.local/bin"
    "/Users/simon/.rd/bin/"
]
# $env.XDG_CONFIG_HOME = "/Users/simon/repos/devenv/.config"
# Nvim som default editor
$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"

# Set up Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
#$env.STARSHIP_CONFIG = '/Users/simon/.config/starship.toml'
#alias config_starship = ^code $env.STARSHIP_CONFIG

# ENV Variables


alias s = simon
alias dev = simon dev
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
source ~/.local/share/atuin/init.nu

# Kör DevPod CLI via bash-login-shell
# def devpod [...args] {
#   with-env { SHELL: "/bin/bash" } {
#     # -l för login-shell så PATH initieras korrekt
#     bash -lc $"devpod ($args | str join ' ')"
#   }
# }
