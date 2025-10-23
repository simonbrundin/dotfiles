# Project Context

## Purpose
This project manages personal dotfiles across multiple machines using chezmoi. It provides a consistent development environment setup including shell configurations, package management, and tool configurations for productivity and development workflows.

## Tech Stack
- Chezmoi: Dotfile manager written in Go for cross-platform dotfile management with templating
- Bash/Zsh: Shell environments with custom configurations and environment variable management
- Atuin: Shell history search and sync tool with TOML configuration
- Devpod: Development environment manager with Docker and Kubernetes providers
- Watchexec: File watcher for automatic chezmoi apply on dotfile changes
- Hammerspoon: macOS automation tool for productivity scripts (e.g., Spotify pause on video)
- Nix: Package manager for reproducible environments (integrated in shell)
- Rancher Desktop: Container and Kubernetes development environment
- Envman: Environment variable manager
- Devbox: Global shell environment manager
- Git: Version control for dotfiles with custom user configuration
- Vim: Text editor with fzf integration for fuzzy finding
- Homebrew: macOS package manager for installing tools like git and Google Chrome

## Project Conventions

### Code Style
- Shell scripts use simple, readable syntax with minimal comments (following chezmoi conventions)
- Configuration files follow their respective format standards (TOML for Atuin/Watchexec, YAML for Devpod/packages)
- Auto-managed sections are marked with clear delimiters (e.g., "### MANAGED BY ... START/END")
- Private configurations are stored in `private_dot_config/` and `private_dot_devpod/` directories
- Chezmoi templating uses `dot_` prefix for home directory files
- Lua scripts for Hammerspoon follow standard Lua conventions
- Vim configuration uses vim-plug for plugin management

### Architecture Patterns
- Flat directory structure with `home/` containing dotfiles (prefixed with `dot_` for chezmoi templating)
- Private configurations separated into `private_dot_config/` and `private_dot_devpod/` subdirectories
- Package management through `.chezmoidata/packages.yaml` with OS-specific sections (currently Darwin/macOS)
- Environment variables managed through envman integration with devbox global shellenv
- Development environments configured via Devpod with Docker and Kubernetes providers
- File watching with watchexec for automatic dotfile application on changes
- macOS automation through Hammerspoon scripts for productivity enhancements

### Testing Strategy
Dotfiles are manually tested across target machines. No automated testing framework is used due to the nature of configuration files. Changes are validated by running `chezmoi apply` and verifying functionality.

### Git Workflow
- Standard Git workflow with main branch as source of truth
- Chezmoi configured for auto-commit and auto-push of changes
- Changes are deployed using `chezmoi apply` on target machines
- Watchexec monitors source directory for changes and auto-applies via chezmoi

## Domain Context
This is a personal dotfiles repository for maintaining consistent development environments across machines. It includes configurations for shell productivity (Bash/Zsh with Atuin history), package management (Homebrew, Nix), development tools (Devpod, Git, Vim), and macOS-specific automation (Hammerspoon) commonly used in software engineering workflows.

## Important Constraints
- Primarily designed for macOS (Darwin) systems
- Personal use only - not intended for multi-user or production environments
- Relies on chezmoi for templating and cross-machine synchronization

## External Dependencies
- Rancher Desktop for container/Kubernetes development
- Atuin cloud sync service (optional)
- Nix package manager
- Homebrew for macOS package management
- 1Password for secure secret storage and retrieval
- Devpod providers (Docker, Kubernetes/Talos cluster)
- Hammerspoon for macOS automation
- Devbox for global shell environment management
- Envman for environment variable management
