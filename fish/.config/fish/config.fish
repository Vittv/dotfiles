set -x PATH $PATH $HOME/.local/bin

# Aliases
alias ls="eza -la --git --icons=always --group-directories-first"
alias grep="grep --color=auto"
alias mudfish="bash ~/.local/bin/mudfish.sh"
alias tdo="nvim ~/Documents/Tasks/todo.md"
alias weather="curl wttr.in"
alias gcd="bash ~/dev/gcd/ui/gcd.sh"

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

# init zoxide and add alias
zoxide init fish | source
alias cd="z"

# fzf keybinds
fzf --fish | source

# fzf-git shortcuts
source ~/build/fzf-git.sh/fzf-git.fish

# FZF options
set -x FZF_CTRL_T_OPTS "--preview 'bat -n --color=always --line-range :500 {}'"
set -x FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization function
function _fzf_comprun
  set command $argv[1]
  set -e argv[1]
  
  switch $command
    case cd
        fzf --preview 'eza --tree --color=always {} | head -200' $argv
    case export unset
        fzf --preview "eval 'echo \$'{}" $argv
    case ssh
        fzf --preview 'dig {}' $argv
    case '*'
        fzf --preview "bat -n --color=always --line-range :500 {}" $argv
  end
end

function ghostty
    env GTK_IM_MODULE=simple /usr/bin/ghostty $argv
end
