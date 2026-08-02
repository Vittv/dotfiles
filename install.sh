#!/usr/bin/env bash

set -e

# prompt for sudo upfront
sudo -v

echo "==> Installing dotfiles"

# enable pac-man progress bar in pacman
echo "==> Configuring pacman..."
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
grep -qxF 'ILoveCandy' /etc/pacman.conf || sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf

echo "==> Installing base dependencies..."
sudo pacman -S --needed --noconfirm git stow base-devel

echo "==> Creating build directory..."
mkdir -p "$HOME/build/"

# yay
echo "==> Installing yay..."
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
else
  echo "  yay already installed, skipping"
fi

echo "==> Configuring yay..."
mkdir -p "$HOME/.config/yay"
cat > "$HOME/.config/yay/config.json" <<'EOF'
{
  "cleanAfter": true,
  "keepSrc": false,
  "removemake": "ask"
}
EOF

# pacman packages
echo "==> Installing packages via pacman..."
sudo pacman -S --needed --noconfirm \
  fish \
  hyprland \
  hyprlock \
  hyprsunset \
  waybar \
  rofi \
  dunst \
  kitty \
  lazygit \
  neovim \
  starship \
  tmux \
  yazi \
  fzf \
  go \
  clang \
  nwg-look \
  qt5ct \
  qt6ct \
  ttf-jetbrains-mono-nerd \
  noto-fonts-cjk \
  noto-fonts-emoji \
  ripgrep \
  fd \
  jq \
  python \
  python-pip \
  wl-clipboard \
  pavucontrol \
  alsa-utils \
  eza \
  zoxide \
  power-profiles-daemon

# yay packages
echo "==> Installing AUR packages..."
yay -S --needed --noconfirm \
  qt6ct-kde \
  nvibrant-bin \
  apple-fonts \
  cmatrix-git \
  peaclock \
  pipes-rs \
  darkly \
  grimblast-git \
  helium-browser-bin \
  hyprqt6engine \
  sesh-bin \
  zen-browser-bin

# performance power profile
echo "==> Enabling power-profiles-daemon..."
if sudo systemctl enable --now power-profiles-daemon; then
  echo "  Enabling performance mode"
  if powerprofilesctl set performance; then
    echo "  performance mode enabled"
  else
    echo "  performance profile not available"
    echo "  Enabling balanced mode"
    powerprofilesctl set balanced
  fi
else
  echo "==> ERROR: failed to enable power-profiles-daemon" >&2
fi

# nvm + Node/npm
echo "==> Installing nvm..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # shellcheck source=/dev/null
  source "$NVM_DIR/nvm.sh"

  echo "==> Installing latest Node (includes npm)..."
  nvm install --lts       # installs latest lts (long-term support)
  nvm use --lts
  nvm alias default "lts/*"
  echo "  Node $(node -v) / npm $(npm -v)"
else
  echo "==> ERROR: nvm.sh not found, skipping Node install" >&2
fi

# TPM (Tmux Plugin Manager)
echo "==> Installing TPM..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "  TPM cloned. After stowing, open tmux and press prefix + I to install plugins."
else
  echo "  TPM already installed, skipping"
fi

# fzf-git
echo "==> Installing fzf-git.sh..."
FZF_GIT_DIR="$HOME/build/fzf-git"
if [ ! -d "$FZF_GIT_DIR" ]; then
  git clone https://github.com/junegunn/fzf-git.sh.git "$FZF_GIT_DIR"
  echo "  fzf-git cloned to $FZF_GIT_DIR — source fzf-git.sh from your shell config."
else
  echo "  fzf-git already present, skipping"
fi

# Flatpak + Flathub
echo "==> Setting up Flatpak..."
sudo pacman -S --needed --noconfirm flatpak gnome-software
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Vague themes
echo "==> Installing Vague themes..."
mkdir -p "$HOME/.themes"

if [ ! -d "$HOME/build/vague-kde" ]; then
  git clone https://github.com/vague-theme/vague-kde.git "$HOME/build/vague-kde"
  mkdir -p ~/.local/share/color-schemes
  cp -p "$HOME/build/vague-kde/Vague.colors" ~/.local/share/color-schemes/
else
  echo "  vague-kde already present, skipping"
fi

if [ ! -d "$HOME/.themes/Vague" ]; then
  git clone https://github.com/vague-theme/vague-gtk.git "$HOME/.themes/Vague"
else
  echo "  Vague already present, skipping"
fi

if [ ! -d "$HOME/build/vague-chromium" ]; then
  git clone https://github.com/vague-theme/vague-chromium.git "$HOME/build/vague-chromium"
else
  echo "  vague-chromium already present, skipping"
fi

# stow dotfiles
echo "==> Stowing dotfiles..."
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for pkg in colors fish hyprland kitty waybar rofi dunst lazygit nvim scripts starship qs tmux yazi ui; do
  if [ -d "$DOTFILES_DIR/$pkg" ]; then
    echo "  stowing $pkg..."
    stow --dir="$DOTFILES_DIR" --target="$HOME" "$pkg"
  else
    echo "  [skip] $pkg directory not found"
  fi
done

# switch shell to fish
echo "==> Switching default shell to fish..."
FISH_PATH="$(command -v fish)"
if [ -n "$FISH_PATH" ]; then
  grep -qxF "$FISH_PATH" /etc/shells || echo "$FISH_PATH" | sudo tee -a /etc/shells
  sudo usermod --shell "$FISH_PATH" "$USER"
else
  echo "==> ERROR: fish not found, skipping shell change" >&2
fi

# done
echo ""
echo "All done! A few manual steps remaining:"
echo "  1. Open a new tmux session and press prefix + I to install plugins via TPM"
echo "  2. Make sure your fish config sources $HOME/build/fzf-git/fzf-git.sh"
echo "  3. Adjust your audio levels with alsamixer"
echo "  4. Apply Vague colors and theme with the GUIs qt5ct, qt6ct, and nwg-look"
echo "  5. Restart your shell or log out for all changes to take effect"
