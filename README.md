<p align="center">
  <a href="https://simonbrundin.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://alfonsofortunato.com/img/logo.png">
      <img src="https://alfonsofortunato.com/img/logo.png" height="90">
    </picture>
    <h1 align="center">Dotfiles MacOS and Linux</h1>
  </a>
</p>

<p align="center">
  <a href="https://github.com/simonbrundin/dotfiles/commit">
    <img alt="LastCommit" src="https://img.shields.io/github/last-commit/simonbrundin/dotfiles/main?style=for-the-badge&logo=github&color=%237dcfff">
  </a>
  <a href="https://github.com/simonbrundin/dotfiles/blob/main/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/simonbrundin/dotfiles?style=for-the-badge&logo=github">
  </a>
</p>

# Dotfiles

Alla dotfiles hanteras med **GNU Stow**.

## Setup

### Automatisk installation

```
curl -sL bootstrap.simonbrundin.com | bash
```

### Manuell installation

1. Klona repot:

   ```
   git clone git@github.com:simonbrundin/dotfiles.git ~/repos/dotfiles
   ```

2. Installera paket (valfritt):

   ```
   brew bundle --file=~/repos/dotfiles/brew/.Brewfile
   ```

3. Skapa symlinks med stow:
   ```
   cd ~/repos/dotfiles
   stow alacritty bash brew hypr kanata neovim nushell opencode omarchy sidecar starship stow tmux tmuxinator voxtype
   ```

## Struktur

Varje applikation har sin konfiguration i en egen katalog:

- `hypr/` → `~/.config/hypr/`
- `neovim/` → `~/.config/nvim/`
- `tmux/` → `~/.config/tmux/` och `~/.tmux.conf`
- etc.
