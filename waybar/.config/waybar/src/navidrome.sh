#!/usr/bin/env bash
player=""
if playerctl -p navitui status &>/dev/null; then
  player="navitui"
elif playerctl -p feishin status &>/dev/null; then
  player="feishin"
else
  for p in $(playerctl -l 2>/dev/null); do
    trackid=$(playerctl -p "$p" metadata mpris:trackid 2>/dev/null)
    url=$(playerctl -p "$p" metadata xesam:url 2>/dev/null)
    if echo "$trackid$url" | grep -qiE "navitui|navidrome|feishin"; then
      player="$p"
      break
    fi
  done
fi
if [[ -z "$player" ]]; then
  echo '{"text":"","class":"empty","tooltip":"No track playing"}'
  exit 1
fi
status=$(playerctl -p "$player" status 2>/dev/null)
info=$(playerctl -p "$player" metadata --format '{{ artist }} — {{ title }}' 2>/dev/null)
full="${info//\\/\\\\}"
full="${full//\"/\\\"}"
vol=$(playerctl -p "$player" volume 2>/dev/null | awk '{printf "%.0f%%", $1*100}')
case "$status" in
  Playing) icon=""; cls="playing" ;;
  Paused)  icon="- "; cls="paused" ;;
  *)       icon=""; cls="playing" ;;
esac
maxlen=60
prefix="$icon $vol "
info="$full"
if [[ ${#info} -gt $(( maxlen - ${#prefix} )) ]]; then
  cut=$(( maxlen - ${#prefix} - 1 ))
  info="${info:0:$cut}…"
fi
echo "{\"text\":\"$prefix$info\",\"class\":\"$cls\",\"tooltip\":\"$vol $status: $full\"}"
