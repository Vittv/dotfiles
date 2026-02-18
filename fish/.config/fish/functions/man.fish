function man
    command man $argv | bat -l man --paging=always --style=-numbers
end
