$env.TALOSCONFIG = '/Users/simon/repos/infrastructure/talos/talosconfig'
$env.VAULT_ADDR = 'https://vault.simonbrundin.com'
$env.KUBECONFIG = '/Users/simon/repos/infrastructure/talos/kubeconfig'
$env.AI_AGENT = 'opencode'
zoxide init nushell | save -f ~/.zoxide.nu
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu