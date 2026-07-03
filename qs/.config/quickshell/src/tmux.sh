#!/usr/bin/env bash
sessions=$(tmux list-sessions -F '#{session_created} #S' 2>/dev/null | sort -n | cut -d' ' -f2- | awk '{n=split($0,a,"/"); if(n>2){r=a[1]; for(i=2;i<=2;i++) r=r"/"a[i]; print r"…"} else print $0}' | awk '{print $0}' | paste -sd ',' - | sed 's/,/, /g')

if [[ -n "$sessions" ]]; then
  echo "{\"text\": \"$sessions\", \"class\": \"tmux-active\", \"tooltip\": \"$sessions\"}"
else
  echo "{\"text\": \"\", \"class\": \"\", \"tooltip\": \"\"}"
fi
