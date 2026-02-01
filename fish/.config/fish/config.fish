set -x PATH $PATH $HOME/.local/bin

# Aliases
alias ls="eza -la --git --icons=always"
alias grep="grep --color=auto"
alias mudfish="bash ~/.local/bin/mudfish.sh"

# Environment variables
set -x EZA_COLORS "di=36"
set -x PATH $HOME/.local/bin $PATH
set -x EDITOR nvim
set -x XDG_DATA_DIRS "/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/usr/local/share:/usr/share"
set -x QT_QPA_PLATFORMTHEME qt5ct

if status is-interactive
# Commands to run in interactive sessions can go here

# Run cutefetch on startup
  if test -x "$HOME/.local/bin/cutefetch"
      $HOME/.local/bin/cutefetch -m bunny -e 9
  end
end

# Starship prompt
starship init fish | source

# No welcome message
set fish_greeting

# fzf keybinds
fzf --fish | source
