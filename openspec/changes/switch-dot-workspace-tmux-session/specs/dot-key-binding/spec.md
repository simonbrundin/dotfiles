## ADDED Requirements

#### Scenario: Switch to workspace 1 and handle alacritty tmux session

Given the user presses the 'dot' key in kanata's tmuxsessions layer

When the key is pressed

Then switch to workspace 1

And check for alacritty windows in workspace 1

If alacritty window exists, focus it and switch tmux session to 'Dotfiles'

If no alacritty window exists, open new alacritty with tmuxinator start 'Dotfiles'