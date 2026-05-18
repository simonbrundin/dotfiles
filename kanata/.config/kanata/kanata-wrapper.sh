#!/bin/bash
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -la /run/user/1000/hypr/ 2>/dev/null | grep -oP '^[^\s_]+' | tail -1)
exec /home/simon/.local/bin/kanata -c /home/simon/.config/kanata/kanata.kbd "$@"