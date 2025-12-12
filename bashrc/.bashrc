#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Run starship automatically on startup
eval "$(starship init bash)"

# Run cutefetch automatically on startup
if [ -x "$HOME/.local/bin/cutefetch" ]; then
    "$HOME/.local/bin/cutefetch" -m bunny -e 9
fi

export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/$USER/.local/share/flatpak/exports/share:/usr/local/share:/usr/share"

export QT_QPA_PLATFORMTHEME=qt5ct
