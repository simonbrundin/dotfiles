# Design for switch-dot-workspace-tmux-session

## Architecture
The change involves kanata (keyboard remapping), hyprland (window manager), alacritty (terminal), and tmux (multiplexer).

## Approach
- Use a bash script called from kanata's 'dot' macro.
- The script uses hyprctl to switch to workspace 1.
- Query hyprctl clients to find alacritty windows in workspace 1.
- If found, focus the window and use wtype to send 'tmux switch-client -t Dotfiles\n' to switch the session.
- If not found, launch alacritty with 'tmuxinator start Dotfiles'.

## Trade-offs
- Assumes wtype is installed for sending keys to focused window.
- Assumes the alacritty window is running tmux and can receive the switch command.
- If multiple alacritty windows in workspace 1, focuses the first one found.
- Minimal complexity by using existing tools.