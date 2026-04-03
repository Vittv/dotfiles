#!/usr/bin/env bash

function buildnvim() {
  local just_cloned=false
  local src_dir="$HOME/build"
  local deps=(base-devel cmake ninja curl git)
  local missing=()

  # Check if build dependencies are installed
  for pkg in "${deps[@]}"; do
    pacman -Q "$pkg" &>/dev/null || missing+=("$pkg")
  done

  # Install them if not
  if (( ${#missing[@]} > 0 )); then
    echo "Installing missing packages for build: ${missing[*]}"
    sudo pacman -S --needed "${missing[@]}"
  else
    echo "All dependencies already installed"
  fi

  # Clone repo into ~/.local/src directory
  mkdir -p "$src_dir"

  if [ ! -d "$src_dir/neovim" ]; then
    git clone https://github.com/neovim/neovim.git "$src_dir/neovim"
    just_cloned=true
  fi

  # cd into it and pull latest changes
  cd "$src_dir/neovim"
  git checkout master

  if ! $just_cloned && git pull | grep -q "Already up to date"; then
    echo "Already up to date, skipping build"
    return
  fi

  # Build nvim
  make CMAKE_BUILD_TYPE=Release
  sudo make install
}

buildnvim "$@"

# To uninstall:
# sudo cmake --build ~/.local/src/neovim/build/ --target uninstall
# or manually:
# sudo rm /usr/local/bin/nvim && sudo rm -r /usr/local/share/nvim/
