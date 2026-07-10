#!/usr/bin/env bash
if pgrep -u root mudrun-headless > /dev/null 2>&1; then
    echo '{"text":"󰱓 ON ","tooltip":"Mudfish VPN is ON","class":"on"}'
else
    echo '{"text":"󰲛 OFF","tooltip":"Mudfish VPN is OFF","class":"off"}'
fi
