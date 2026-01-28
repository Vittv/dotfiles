#!/bin/bash

PROJECTS_DIR="$HOME/manoir"

if [ ! -d "$PROJECTS_DIR" ]; then
    notify-send "Error" "Projects directory not found: $PROJECTS_DIR"
    exit 1
fi

projects=$(find "$PROJECTS_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort)

selected=$(echo "$projects" | rofi -dmenu -i -p "" -theme-str "element { children: [element-text]; } element-text { padding: 0 0 0 10px; }")

if [ -n "$selected" ]; then
    kitty --directory "$PROJECTS_DIR/$selected" tmux new-session -A -s "$selected" &
fi
