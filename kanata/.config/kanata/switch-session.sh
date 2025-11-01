#!/bin/bash

session_name=${1:-Dotfiles}

# Set environment
export PATH=/usr/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:$PATH
export WAYLAND_DISPLAY=$WAYLAND_DISPLAY
export XDG_RUNTIME_DIR=/run/user/$(id -u)

hyprctl dispatch workspace 1

hyprctl keyword animations:enabled 0

alacritty_addresses=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id == 1 and .class == "Alacritty") | .address')

for addr in $alacritty_addresses; do
  hyprctl dispatch closewindow address:$addr
done

hyprctl keyword animations:enabled 1

uwsm-app -- alacritty -e tmuxinator start $session_name &