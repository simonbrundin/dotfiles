#!/bin/bash

REPOS_DIR="$HOME/repos"
SEP=" "

# Catppuccin Mocha färger (använd tmux-format)
COLOR_DIRTY="#(#{E:@catppuccin_flavour} == 'mocha' && echo '#f38ba8' || echo '#ee99a0')"  # rosewater → red för dirty
COLOR_CLEAN="#(#{E:@catppuccin_flavour} == 'mocha' && echo '#a6e3a1' || echo '#94e2d5')"  # green

dirty_repos=()

for repo in "$REPOS_DIR"/*/; do
  repo_path="${repo%/}"
  [[ ! -d "$repo_path/.git" ]] && continue

  cd "$repo_path" 2>/dev/null || continue

  # Kolla om det finns uncommitted changes (staged eller unstaged)
  if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    name=$(basename "$repo_path")
    dirty_repos+=("$name")
  fi
done

# Output
if [[ ${#dirty_repos[@]} -eq 0 ]]; then
  echo
  # echo "#[fg=#343246,bg=#1e1e2e]#[fg=#cdd6f4,bg=#343246] inga dirty #[fg=#343246,bg=#1e1e2e]"
else
  output=""
  for name in "${dirty_repos[@]}"; do
    output+="#[fg=#343246,bg=#1e1e2e]#[fg=#cdd6f4,bg=#343246] $name #[fg=#343246,bg=#1e1e2e] "
  done
  echo "$output"
fi
