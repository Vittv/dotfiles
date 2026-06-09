function t
  sesh connect "$(sesh list --icons | fzf --no-sort --ansi --border --border-label " sesh " --prompt " " --header " ^t tmux ^z zoxide" --bind "ctrl-t:change-prompt( )+reload(sesh list -t --icons)" --bind "ctrl-z:change-prompt( )+reload(sesh list -z --icons)")"
end
