#!/usr/bin/env bash

player=""

if playerctl -p spotify status &>/dev/null; then
  player="spotify"
else
  for p in $(playerctl -l 2>/dev/null); do
    trackid=$(playerctl -p "$p" metadata mpris:trackid 2>/dev/null)
    url=$(playerctl -p "$p" metadata xesam:url 2>/dev/null)
    echo "$trackid$url" | grep -qi spotify && player="$p" && break
  done
fi

if [[ -z "$player" ]]; then
  exit 1
fi

playerctl -p "$player" "$@"
