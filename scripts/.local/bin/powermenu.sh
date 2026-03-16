#!/bin/bash

chosen=$(printf "󰐥   Power Off\n󰜉   Restart\n󰌾   Lock\n󰍃   Logout\n󰤄   Suspend\n󰒲   Hibernate" | rofi -dmenu \
  -theme-str 'mainbox {children: [listview];}' \
  -theme-str 'window {width: 200px;}' \
  -theme-str 'listview {lines: 6;}' \
  -theme-str 'element-text {padding: 0px;}' \
  -theme-str 'configuration {show-icons: false;}' -p "Power Menu")

case "$chosen" in
    "󰐥   Power Off") poweroff ;;
    "󰜉   Restart") reboot ;;
    "󰌾   Lock") hyprlock ;;
    "󰍃   Logout") loginctl kill-session $XDG_SESSION_ID ;;
    "󰤄   Suspend") systemctl suspend ;;
    "󰒲   Hibernate") systemctl hibernate ;;
esac
