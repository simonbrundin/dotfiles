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
  <a href="https://github.com/MovieMaker93/devpod-dotfiles-chezmoi/commit">
    <img alt="LastCommit" src="https://img.shields.io/github/last-commit/simonbrundin/dotfiles/main?style=for-the-badge&logo=github&color=%237dcfff">
  </a>
  <!-- <a href="https://github.com/MovieMaker93/devpod-dotfiles-chezmoi/actions/workflows/"> -->
  <!-- </a> -->
  <a href="https://github.com/MovieMaker93/devpod-dotfiles-chezmoi/blob/main/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/MovieMaker93/devpod-dotfiles-chezmoi?style=for-the-badge&logo=github">
  </a>
  <a href="https://github.com/MovieMaker93/devpod-dotfiles-chezmoi/stars">
    <img alt="stars" src="https://img.shields.io/github/stars/MovieMaker93/devpod-dotfiles-chezmoi?style=for-the-badge&logo=github&color=%23f7768e">
  </a>
</p>

# Dotfiles

Alla mina dotfiles går att installera genom

```
curl
```

## Setup

1. Install chezmoi:
   `sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$HOME/.local/bin"`
2. Clone and apply:
   `chezmoi init --apply https://github.com/yourusername/dotfiles`
3. For 1Password integration:
   - Install 1Password CLI: `brew install 1password-cli`
   - Sign in: `op signin`
   - Ensure vault "dotfiles" exists with item "mcp-auth" containing the
4.
