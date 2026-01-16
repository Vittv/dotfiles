#!/bin/bash
chosen=$(printf "󰐥\n󰍃\n󰌾\n󰤄\n󰜉\n󰒲" | rofi -dmenu -no-custom \
    -theme-str 'mainbox {children: [listview];}' \
    -theme-str 'window {width: 360px;}' \
    -theme-str 'listview {columns: 3; lines: 2; spacing: 15px; fixed-columns: true;}' \
    -theme-str 'element {padding: 22px; border-radius: 8px;}' \
    -theme-str 'element-text {horizontal-align: 0.5; vertical-align: 0.5; padding: 0px;}' \
    -theme-str 'configuration {show-icons: false; font: "AdwaitaMono Nerd Font Propo 28";}' \
    -p "")

case "$chosen" in
    "󰐥") poweroff ;;
    "󰜉") reboot ;;
    "󰌾") hyprlock ;;
    "󰍃") loginctl kill-session $XDG_SESSION_ID ;;
    "󰤄") systemctl suspend ;;
    "󰒲") systemctl hibernate ;;
    *) exit 1 ;;
esac


