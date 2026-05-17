function t
    tmux new-session sesh connect (sesh list | fzf --height 40% --border rounded --border-label ' manoir ')
end
