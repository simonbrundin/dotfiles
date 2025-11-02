#!/bin/bash

current=$(hyprctl activeworkspace -j | jq -r '.id')

if [ "$current" -eq 5 ]; then
    hyprctl dispatch workspace previous
else
    hyprctl dispatch workspace 5
fi
