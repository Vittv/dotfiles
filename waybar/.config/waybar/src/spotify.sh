#!/usr/bin/env bash

player=""

if playerctl -p spotify status &>/dev/null; then
  player="spotify"
else
  for p in $(playerctl -l 2>/dev/null); do
    trackid=$(playerctl -p "$p" metadata mpris:trackid 2>/dev/null)
    url=$(playerctl -p "$p" metadata xesam:url 2>/dev/null)
    if echo "$trackid$url" | grep -qi spotify; then
      player="$p"
      break
    fi
  done
fi

if [[ -z "$player" ]]; then
  echo '{"text":""}'
  exit 1
fi

status=$(playerctl -p "$player" status 2>/dev/null)
info=$(playerctl -p "$player" metadata --format '{{ title }} - {{ artist }}' 2>/dev/null \
  | sed 's/"/\\"/g' \
  | sed 's/&/\&/g' \
  | sed 's/</\</g' \
  | sed 's/>/\>/g')
vol=$(playerctl -p "$player" volume 2>/dev/null | awk '{printf "%.0f%%", $1*100}')

if [[ "$status" == "Playing" ]]; then
  icon="󰓇 $vol $info"
elif [[ "$status" == "Paused" ]]; then
  icon="⏸ $vol $info"
fi

echo "{\"text\":\"$icon\",\"tooltip\":\"$vol $status: $info\"}"
