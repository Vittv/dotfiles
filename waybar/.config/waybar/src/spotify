#!/usr/bin/env bash

SCROLL_LEN=30
SCROLL_SPEED=3
STATE_FILE="/tmp/waybar-spotify-scroll"

line=$(playerctl -p spotify metadata --format '{{ title }} — {{ artist }}' 2>/dev/null)

if [[ -z "$line" ]]; then
  for p in $(playerctl -l 2>/dev/null); do
    trackid=$(playerctl -p "$p" metadata mpris:trackid 2>/dev/null)
    url=$(playerctl -p "$p" metadata xesam:url 2>/dev/null)
    if echo "$trackid$url" | grep -qi spotify; then
      line=$(playerctl -p "$p" metadata --format '{{ title }} — {{ artist }}' 2>/dev/null)
      break
    fi
  done
fi

if [[ -z "$line" ]]; then
  printf -v display "%*s" "$SCROLL_LEN" ""
  echo "{\"text\":\"$display\",\"class\":\"empty\",\"tooltip\":\"No track playing\"}"
  exit 0
fi

buf="$line"

prev_buf=""
pos=0
if [[ -f "$STATE_FILE" ]]; then
  { IFS= read -r prev_buf; read pos; } < "$STATE_FILE" 2>/dev/null
fi

if [[ "$prev_buf" != "$buf" ]]; then
  pos=0
fi

full="$buf   $buf"
display="${full:$pos:$SCROLL_LEN}"
display="${display//\\/\\\\}"
display="${display//\"/\\\"}"
escaped_line="${line//\\/\\\\}"
escaped_line="${escaped_line//\"/\\\"}"
echo "{\"text\":\"$display\",\"tooltip\":\"$escaped_line\"}"

pos=$(( pos + SCROLL_SPEED ))
if [[ $pos -ge $(( ${#buf} + 3 )) ]]; then
  pos=0
fi

printf '%s\n' "$buf" "$pos" > "$STATE_FILE"
