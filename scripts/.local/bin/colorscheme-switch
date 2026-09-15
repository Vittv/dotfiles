#!/bin/bash
SCHEME=$1

cd ~/.config/colors
rm current
ln -s schemes/$SCHEME current

# Reload everything
hyprctl reload
killall waybar && waybar &
# rofi doesn't need reloading
