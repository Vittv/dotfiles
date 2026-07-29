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

# # Run cutefetch or fastfetch automatically on startup (50/50 chance)
# if [ -x "$HOME/.local/bin/cutefetch" ]; then
#     if [ $((RANDOM % 2)) -eq 0 ]; then
#         "$HOME/.local/bin/cutefetch" -m bunny -e 9
#     else
#         fastfetch --config os
#     fi
# fi

export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/$USER/.local/share/flatpak/exports/share:/usr/local/share:/usr/share"

export QT_QPA_PLATFORMTHEME=qt5ct

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

export EDITOR=nvim
