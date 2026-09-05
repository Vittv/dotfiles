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
    echo "$trackid$url" | grep -qiE "navitui|navidrome|feishin" && player="$p" && break
  done
fi

[[ -n "$player" ]] || exit 1

if [[ $1 == volume ]]; then
  if [[ $# -eq 1 ]]; then
    exec playerctl -p "$player" volume
  fi
  arg=$2
  case $arg in
    *+) op='+' ;;
    *-) op='-' ;;
    *)  op='=' ;;
  esac
  scale=1; [[ $arg == *%* ]] && scale=0.01
  amt=$(tr -d '%+-' <<<"$arg")
  cur=$(playerctl -p "$player" volume 2>/dev/null) || exit 1
  new=$(awk -v c="$cur" -v a="$amt" -v s="$scale" -v o="$op" 'BEGIN {
    v = o == "+" ? c + a*s : o == "-" ? c - a*s : a*s
    if (v < 0) v = 0
    if (v > 1) v = 1
    printf "%.2f", v
  }')
  exec playerctl -p "$player" volume "$new"
fi

exec playerctl -p "$player" "$@"
