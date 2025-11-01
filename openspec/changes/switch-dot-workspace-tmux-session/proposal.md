# Change Proposal: switch-dot-workspace-tmux-session

## Summary
Modify the 'dot' key binding in kanata's tmuxsessions layer to switch to workspace 1 and ensure the tmuxinator session in alacritty is set to 'Dotfiles'. If no alacritty window exists in workspace 1, open a new one with the Dotfiles session. If an alacritty window exists, focus it and switch its tmux session to Dotfiles.

## Motivation
The current implementation always opens a new alacritty window, which the user wants to avoid if one is already present in workspace 1.

## Requirements
- Switch to workspace 1 when 'dot' is pressed in tmuxsessions layer.
- Check for existing alacritty windows in workspace 1.
- If alacritty exists, focus it and switch tmux session to 'Dotfiles'.
- If no alacritty exists, open a new alacritty with tmuxinator start Dotfiles.

## Acceptance Criteria
- Pressing 'dot' in tmuxsessions layer switches to workspace 1.
- No new alacritty window is opened if one already exists in workspace 1.
- The tmux session in the alacritty is switched to or starts as 'Dotfiles'.