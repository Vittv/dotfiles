#!/usr/bin/env bash
set -e

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

# pacman packages
echo "==> Installing packages via pacman..."
sudo pacman -S --needed --noconfirm \
  fish \
  hyprland \
  kitty \
  lazygit \
  neovim \
  rofi \
  starship \
  swaync \
  tmux \
  waybar \
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
  python \
  python-pip \
  wl-clipboard \
  pavucontrol \
  alsa-utils

# yay packages
yay -S --needed --noconfirm \
  qt6ct-kde \
  nvibrant-bin

# nvm + Node/npm
echo "==> Installing nvm..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
source "$NVM_DIR/nvm.sh"

echo "==> Installing latest Node (includes npm)..."
nvm install --lts       # installs latest lts (long-term support)
nvm use --lts
nvm alias default "lts/*"
echo "  Node $(node -v) / npm $(npm -v)"

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

# I'll have to add this later when I submit a wm version for qt only not kde
# if [ ! -d "$HOME/.themes/vague-kde" ]; then
#   git clone https://github.com/vague-theme/vague-kde.git "$HOME/build/vague-kde"
# else
#   echo "  vague-kde already present, skipping"
# fi

if [ ! -d "$HOME/.themes/Vague" ]; then
  git clone https://github.com/vague-theme/vague-gtk.git "$HOME/.themes/Vague"
else
  echo "  Vague already present, skipping"
fi

if [ ! -d "$HOME/.themes/vague-chromium" ]; then
  git clone https://github.com/vague-theme/vague-chromium.git "$HOME/build/vague-chromium"
else
  echo "  vague-chromium already present, skipping"
fi

# Stow dotfiles
echo "==> Stowing dotfiles..."
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for pkg in colors fish hyprland kitty lazygit nvim rofi scripts starship swaync tmux waybar yazi ui; do
  if [ -d "$DOTFILES_DIR/$pkg" ]; then
    echo "  stowing $pkg..."
    stow --dir="$DOTFILES_DIR" --target="$HOME" "$pkg"
  else
    echo "  [skip] $pkg directory not found"
  fi
done

# Switch shell to fish
# Ensure fish is in /etc/shells (pacman should do this, but guard anyway)
grep -qxF '/usr/bin/fish' /etc/shells || echo '/usr/bin/fish' | sudo tee -a /etc/shells

# Change shell without password prompt
sudo usermod --shell /usr/bin/fish "$USER"

# Done
echo ""
echo "All done! A few manual steps remaining:"
echo "  1. Open a new tmux session and press prefix + I to install plugins via TPM"
echo "  2. Make sure your fish config sources $HOME/build/fzf-git/fzf-git.sh"
echo "  3. Adjust your audio levels with alsamixer"
echo "  4. Restart your shell or log out for all changes to take effect"
