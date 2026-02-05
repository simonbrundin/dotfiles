$env.TALOSCONFIG = '/home/simon/repos/infrastructure/talos/talosconfig'
$env.VAULT_ADDR = 'https://vault.simonbrundin.com'
$env.KUBECONFIG = "/home/simon/.tsh/keys/teleport.simonbrundin.com/admin-kube/teleport.simonbrundin.com/localproxy-8443-kubeconfig"
# $env.KUBECONFIG = '/home/simon/repos/infrastructure/talos/kubeconfig'
$env.AI_AGENT = 'opencode'
zoxide init nushell | save -f ~/.zoxide.nu
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir $"($nu.cache-dir)"
# carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"

# OpenCode with notifications
def oo [] { bash ~/.config/agent-os/scripts/opencode-watch.sh run }
def oo-wait [] { bash ~/.config/agent-os/scripts/opencode-watch.sh wait }
