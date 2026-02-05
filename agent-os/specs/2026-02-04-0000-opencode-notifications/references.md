# References: OpenCode Notification System

## Similar Patterns in Codebase

### Notification Usage (kanata)

Location: `kanata/.config/kanata/kanata.kbd:38-41`

```kanata
c (tap-hold $tap-time $hold-time c (macro M-c (cmd notify-send "Kopierat!")))
y (tap-hold $tap-time $hold-time y (macro M-c (cmd notify-send "Kopierat!")))
v (tap-hold $tap-time $hold-time v (macro M-v (cmd notify-send "Klistrat in!")))
p (tap-hold $tap-time $hold-time p (macro M-v (cmd notify-send "Klistrat in!")))
```

Pattern: Simple notify-send calls for user feedback
Takeaway: Short, clear messages work well

### Neovim Notifications

Location: `neovim/.config/nvim/lua/config/keymaps.lua:15,42`

```lua
vim.notify("Not on a todo line", vim.log.levels.WARN)
```

Pattern: Built-in notification system with severity levels
Takeaway: Severity levels help prioritize notifications

### Shell Script Pattern

Location: `agent-os/scripts/common-functions.sh`

Pattern to follow for notification helper:
```bash
set -e
local function variables
command availability checks
```

## External Documentation

- `notify-send` man page: `man notify-send`
- Notify-send urgency levels: low, normal, critical

## Command Files to Modify

1. `opencode/.config/opencode/commands/work.md` - Notify before question, notify on selection
2. `opencode/.config/opencode/commands/shape-spec.md` - Notify at key decision points
3. `opencode/.config/opencode/commands/openspec-apply.md` - Notify on task completion
4. Other commands as needed

## Files to Create

1. `agent-os/scripts/notify.sh` - Notification helper script
