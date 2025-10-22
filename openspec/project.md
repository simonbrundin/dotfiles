# Project Context

## Purpose
This project manages personal dotfiles across multiple machines using chezmoi. It provides a consistent development environment setup including shell configurations, package management, and tool configurations for productivity and development workflows.

## Tech Stack
- Chezmoi: Dotfile manager written in Go for cross-platform dotfile management
- Bash/Zsh: Shell environments with custom configurations
- Atuin: Shell history search tool with TOML configuration
- Nix: Package manager for reproducible environments
- Rancher Desktop: Container and Kubernetes development environment
- Envman: Environment variable manager
- Git: Version control for dotfiles

## Project Conventions

### Code Style
- Shell scripts use simple, readable syntax with clear comments
- Configuration files follow their respective format standards (TOML for Atuin, YAML for packages)
- Auto-managed sections are marked with clear delimiters (e.g., "### MANAGED BY ... START/END")
- Private configurations are stored in `private_dot_config/` directory

### Architecture Patterns
- Flat directory structure with `home/` containing dotfiles (prefixed with `dot_` for chezmoi templating)
- Private configurations separated into `private_dot_config/` subdirectories
- Package management through `.chezmoidata/packages.yaml` with OS-specific sections
- Environment variables managed through envman integration

### Testing Strategy
Dotfiles are manually tested across target machines. No automated testing framework is used due to the nature of configuration files.

### Git Workflow
- Standard Git workflow with main branch as source of truth
- Commits follow conventional commit messages when applicable
- Changes are deployed using `chezmoi apply` on target machines

## Domain Context
This is a personal dotfiles repository for maintaining consistent development environments. It includes configurations for shell productivity, package management, and development tools commonly used in software engineering.

## Important Constraints
- Primarily designed for macOS (Darwin) systems
- Personal use only - not intended for multi-user or production environments
- Relies on chezmoi for templating and cross-machine synchronization

## External Dependencies
- Rancher Desktop for container/Kubernetes development
- Atuin cloud sync service (optional)
- Nix package manager
- Homebrew for macOS package management
