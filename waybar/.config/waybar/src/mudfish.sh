#!/usr/bin/env bash
if pgrep -u root mudrun-headless > /dev/null 2>&1; then
    text="<span color='#7fa563'>▪</span>󰱓"
    tip="Mudfish VPN is ON"
    cls="on"
else
    text="<span color='#d8647e'>▪</span>󰅛"
    tip="Mudfish VPN is OFF"
    cls="off"
fi
printf '{"text":"%s","tooltip":"%s","class":"%s","markup":"pango"}\n' \
    "$text" "$tip" "$cls"
