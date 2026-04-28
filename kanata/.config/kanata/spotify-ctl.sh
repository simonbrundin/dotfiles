#!/bin/bash

action=$1

case $action in
  next)
    xdotool search --onlyvisible --name "Spotify" key --clearmodifiers "ctrl+Right"
    ;;
  prev)
    xdotool search --onlyvisible --name "Spotify" key --clearmodifiers "ctrl+Left"
    ;;
  play)
    xdotool search --onlyvisible --name "Spotify" key --clearmodifiers "ctrl+space"
    ;;
esac