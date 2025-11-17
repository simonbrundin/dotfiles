#!/bin/bash

# Take all arguments as session name, default to Dotfiles
if [ $# -eq 0 ]; then
  session_name="Dotfiles"
else
  # Replace + or _ with spaces to support names like "Simon+CLI" -> "Simon CLI"
  session_name="${*//+/ }"
  session_name="${session_name//_/ }"
fi

# Set environment
export PATH=/usr/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:$PATH
export WAYLAND_DISPLAY=$WAYLAND_DISPLAY
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Switch to workspace 1
hyprctl dispatch workspace 1

# Check if session exists, if not create it
if ! tmux has-session -t "$session_name" 2>/dev/null; then
  # Try to find the tmuxinator config file
  # Convert to lowercase and replace spaces with hyphens for filename
  tmuxinator_project=$(echo "$session_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

  # Check if the tmuxinator project exists
  if tmuxinator list | grep -q "^$tmuxinator_project$"; then
    tmuxinator start "$tmuxinator_project" -d
  else
    # Fallback to original session name
    tmuxinator start "$session_name" -d
  fi
fi

# Get the Alacritty window on workspace 1
alacritty_addr=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id == 1 and .class == "Alacritty") | .address' | head -1)

if [ -n "$alacritty_addr" ]; then
  # Focus the existing window and switch session
  hyprctl dispatch focuswindow address:$alacritty_addr
  # Send the tmux switch command to the terminal
  tmux switch-client -t "$session_name" 2>/dev/null || {
    # If no client is attached, attach to it
    alacritty_pid=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$alacritty_addr\") | .pid")
    if [ -n "$alacritty_pid" ]; then
      tmux_pid=$(pgrep -P "$alacritty_pid" tmux | head -1)
      if [ -n "$tmux_pid" ]; then
        tmux -S /tmp/tmux-$(id -u)/default switch-client -t "$session_name"
      fi
    fi
  }
else
  # No Alacritty window found, create one
  uwsm-app -- alacritty -e tmuxinator start "$session_name" &
fi