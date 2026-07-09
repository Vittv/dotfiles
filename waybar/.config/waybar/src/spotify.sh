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
  icon="󰓇"
elif [[ "$status" == "Paused" ]]; then
  icon="⏸"
fi

text="$vol $info"
VISIBLE_LEN=26
STATE_FILE="/tmp/waybar-spotify-scroll"

if [[ ${#text} -le $VISIBLE_LEN ]]; then
  echo "{\"text\":\"$icon $text\",\"tooltip\":\"$vol $status: $info\"}"
  exit 0
fi

# Bounce scroll: store "pos dir" in state file
pos=0
dir=1
if [[ -f "$STATE_FILE" ]]; then
  read pos dir < "$STATE_FILE"
fi

padded="   $text   "
len=${#padded}

pos=$(( pos + dir ))

# Reverse at edges
if [[ $pos -le 0 ]]; then
  pos=0
  dir=1
elif [[ $(( pos + VISIBLE_LEN )) -ge $len ]]; then
  pos=$(( len - VISIBLE_LEN ))
  dir=-1
fi

echo "$pos $dir" > "$STATE_FILE"

display="${padded:$pos:$VISIBLE_LEN}"
echo "{\"text\":\"$icon $display\",\"tooltip\":\"$vol $status: $info\"}"
