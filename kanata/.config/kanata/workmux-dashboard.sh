#!/bin/bash
hyprctl dispatch "hl.dsp.focus({ workspace = '1' })"
tmux popup -d . -w 90% -h 90% -x C -y C -E 'workmux dashboard'
