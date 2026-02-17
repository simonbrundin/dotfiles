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

# Switch to workspace 1
hyprctl dispatch workspace 1

# Get the Ghostty window on workspace 1
ghostty_addr=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id == 1 and .class == "com.mitchellh.ghostty") | .address' | head -1)

if [ -n "$ghostty_addr" ]; then
  # Try to switch tmux session using switch-client
  if tmux switch-client -t "$session_name" 2>/dev/null; then
    # Successfully switched, just focus the window
    hyprctl dispatch focuswindow address:$ghostty_addr
  else
    # No client attached - create new window with session
    uwsm-app -- ghostty +new-window -e tmuxinator start "$session_name" -d &
  fi
else
  # No Ghostty window found, create one with the session
  uwsm-app -- ghostty +new-window -e tmuxinator start "$session_name" -d &
fi