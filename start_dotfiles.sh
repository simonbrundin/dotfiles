#!/bin/bash
echo "Starting tmuxinator Dotfiles at $(date)" >> ~/kanata_log.txt
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
alacritty -e 'tmux attach-session -t Dotfiles || tmuxinator start Dotfiles' &
echo "Done" >> ~/kanata_log.txt