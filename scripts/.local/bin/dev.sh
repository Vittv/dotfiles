#!/usr/bin/env bash

PROJECTS_DIR="$HOME/dev"
DOCUMENTS_DIR="$HOME/Documents"

PRIORITY_PROJECTS=("Tasks" "Academia" "zettelkasten")

if [ ! -d "$PROJECTS_DIR" ]; then
    notify-send "Error" "Projects directory not found: $PROJECTS_DIR"
    exit 1
fi

priority_list=""
for proj in "${PRIORITY_PROJECTS[@]}"; do
    if [ -d "$DOCUMENTS_DIR/$proj" ]; then
        priority_list+="$proj"$'\n'
    fi
done

regular_projects=$(find "$PROJECTS_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort)

projects="${priority_list}${regular_projects}"

selected=$(echo "$projects" | rofi -dmenu -i -p "" -theme-str "element { children: [element-text]; } element-text { padding: 0 0 0 10px; }")

if [ -n "$selected" ]; then
    if [[ " ${PRIORITY_PROJECTS[@]} " =~ " ${selected} " ]]; then
        target_dir="$DOCUMENTS_DIR/$selected"
    else
        target_dir="$PROJECTS_DIR/$selected"
    fi
    
    kitty --directory "$target_dir" tmux new-session -A -s "$selected" &
fi
