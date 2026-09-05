#!/usr/bin/env bash

playerctl -p spotify status &>/dev/null && exit 0

for p in $(playerctl -l 2>/dev/null); do
  trackid=$(playerctl -p "$p" metadata mpris:trackid 2>/dev/null)
  url=$(playerctl -p "$p" metadata xesam:url 2>/dev/null)
  echo "$trackid$url" | grep -qi spotify && exit 0
done

exit 1
spotify.sh
