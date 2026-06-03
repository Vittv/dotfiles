#!/usr/bin/env bash

status=$(playerctl -p spotify status 2>/dev/null)
info=$(playerctl -p spotify metadata --format '{{ title }} - {{ artist }}' 2>/dev/null \
  | sed 's/"/\\"/g' \
  | sed 's/&/\&amp;/g' \
  | sed 's/</\&lt;/g' \
  | sed 's/>/\&gt;/g')
vol=$(playerctl -p spotify volume 2>/dev/null | awk '{printf "%.0f%%", $1*100}')

if [[ "$status" == "Playing" ]]; then
  icon="󰓇 $vol $info"
elif [[ "$status" == "Paused" ]]; then
  icon="⏸ $vol $info"
fi

echo "{\"text\":\"$icon\",\"tooltip\":\"$vol $status: $info\"}"
