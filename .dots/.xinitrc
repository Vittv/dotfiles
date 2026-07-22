#!/bin/sh

# env
export XCURSOR_THEME=mactahoe
export XCURSOR_SIZE=26
xsetroot -cursor_name left_ptr
export PATH="$HOME/.local/bin/dwm:$PATH"

# keyboard speed and delay
xset r rate 250 50

# nvidia saturation boost
nvidia-settings -a "DigitalVibrance=307" &

# set wallpaper
[ -f ~/.fehbg ] && . ~/.fehbg &

# set notification daemon
dunst &

# set night light
redshift &

# set monitor outputs
xrandr --output DP-0 --mode 1920x1080 --rate 144 --primary \
       --output HDMI-0 --mode 1920x1080 --rate 60 --right-of DP-0

# disable screensaver and screen blanking
xset s off
xset -dpms

# wait for monitors to settle
sleep 1

# set polybar after xrandr
~/.config/polybar/src/launch.sh &

# start dwm
pkill -f "xsetroot -name"
~/build/dwm/scripts/xsetloop &
exec dbus-run-session dwm
