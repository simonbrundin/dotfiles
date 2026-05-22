#!/bin/bash
export HYPRLAND_INSTANCE_SIGNATURE=$(ls /run/user/1000/hypr/ 2>/dev/null)
exec /home/simon/.local/bin/kanata -c /home/simon/.config/kanata/kanata.kbd "$@"