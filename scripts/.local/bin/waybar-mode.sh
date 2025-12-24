#!/bin/bash
# waybar mode switcher

PROFILE=$1

# If no argument, list available profiles
if [ -z "$PROFILE"]; then
  ls ~/.config/waybar/profiles/
  exit 0
fi

cd ~/.config/waybar/
rm config style.css
ln -s profiles/$PROFILE/config config
ln -s profiles/$PROFILE/style.css style.css
killall waybar && waybar &
