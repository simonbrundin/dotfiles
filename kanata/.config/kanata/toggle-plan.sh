#!/bin/bash

current=$(hyprctl activeworkspace -j | jq -r '.id')

if [ "$current" -eq 5 ]; then
    hyprctl dispatch "hl.dsp.focus({ workspace = 'previous' })" 2>/dev/null || hyprctl dispatch "workspace previous"
else
    hyprctl dispatch "hl.dsp.focus({ workspace = '5' })"
fi
