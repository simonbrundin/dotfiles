## MANDATORY: Use td for Task Management

You must run td usage --new-session at conversation start (or after /clear) to see current work.
Use td usage -q for subsequent reads.

<!-- OPENSPEC:START -->

# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:

- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:

- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# AGENTS.md - Dotfiles Repository

This repository contains configuration files (dotfiles) for macOS and Linux development environments.

## Project Structure

```
dotfiles/
├── alacritty/         # Terminal emulator config
├── hypr/              # Hyprland window manager
├── kanata/            # Keyboard remapper
├── neovim/            # Editor configuration (lua)
├── nushell/           # Shell config
├── omarchy/           # Desktop environment
├── starship/          # Prompt
├── tmux/              # Terminal multiplexer
├── stow/              # Symlink manager
├── opencode/          # OpenCode IDE config
├── openspec/          # Change proposal system
└── agent-os/          # AI agent standards system
```

## Build/Lint/Test Commands

This is a dotfiles repository - no traditional build system. However:

### Stow (Symlink Management)

```bash
# Dry-run to see what would be symlinked
stow -nvt ~ */

# Apply dotfiles (install)
stow -vt ~ */

# Remove dotfiles
stow -vt ~ */ -D
```

### Shell Script Validation

```bash
# Check shell scripts for syntax errors
bash -n /path/to/script.sh

# Run shellcheck on scripts
shellcheck /path/to/script.sh
```

### Neovim Lua Validation

```bash
# Check lua syntax (from neovim directory)
luac -p lua/config/*.lua

# Check lua with luacheck
luacheck lua/
```

### TOML Validation

```bash
# Validate TOML files
toml-validate config.toml
```

## Code Style Guidelines

### Shell Scripts (Bash)

- Use `#!/bin/bash` shebang
- Use `set -e` for error handling
- Use `[[ ]]` for conditionals (not `[ ]`)
- Use `$()` for command substitution
- Quote variables: `"$VAR"` not `$VAR`
- Use `snake_case` for variables and functions
- Add descriptive comments for complex logic
- Use `local` for function variables

### Lua (Neovim Configuration)

- Follow stylua.toml: 2-space indent, 120 column width
- Use `snake_case` for variables and functions
- Use `local` scope by default
- Use `vim.opt` for vim options
- Use descriptive module names: `lua/config/options.lua`

### TOML Configuration

- Use lowercase with underscores: `indent_width = 2`
- Group related settings together
- Add comments for non-obvious settings

### General

- Minimal comments unless explaining complex logic
- Consistent naming conventions per file type
- Keep files focused and modular

## Git Workflow

1. Create feature branch for changes
2. Make focused, atomic commits
3. Write descriptive commit messages
4. Test changes manually before committing
5. Push and create PR for significant changes

## OpenSpec Integration

For planning and proposals:

1. **Create proposal**: Run OpenCode command to create change proposal
2. **Add specs**: Create spec files in `openspec/changes/{name}/specs/`
3. **Add tasks**: Create tasks.md with implementation steps
4. **Apply changes**: Run openspec-apply command

See `@/openspec/AGENTS.md` for detailed OpenSpec instructions.

## Agent OS Standards

This project uses Agent OS for AI agent standards:

- **Discover Standards**: Extract patterns from codebase
- **Inject Standards**: Apply relevant standards during work
- **Shape Spec**: Create better implementation plans
- **Index Standards**: Keep standards organized

Run OpenCode commands to access these features.

## Environment-Specific Files

- macOS specific: Use `.macos` suffix or `macos/` directory
- Linux specific: Use `.linux` suffix or `linux/` directory
- Both: Standard files without suffix

## Special Tools Used

- **chezmoi**: Dotfile management (install via bootstrap.simonbrundin.com)
- **kanata**: Keyboard remapping with cmd feature enabled
- **1Password CLI**: Secret management integration
- **stow**: Symlink-based dotfile deployment

## Notifications

When OpenCode needs user input OR finishes a task, ALWAYS send a system notification:

### When Waiting for Input

Before using the `question` tool or otherwise waiting for user response:

```bash
notify-send -u normal "OpenCode: Question" "OpenCode väntar på dig - kolla terminalen"
```

### When Task Completes

After completing a task or finishing work:

```bash
notify-send -u low "OpenCode: Complete" "OpenCode är färdig"
```

This applies to ALL interactions - every question and every completion should trigger a notification so the user knows when to respond and when work is done.
