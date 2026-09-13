#!/bin/bash
export HYPRLAND_INSTANCE_SIGNATURE=$(find /run/user/1000/hypr -mindepth 1 -maxdepth 1 -type d -printf '%T@ %f\n' 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
exec /home/simon/.local/bin/kanata -c /home/simon/.config/kanata/kanata.kbd "$@"