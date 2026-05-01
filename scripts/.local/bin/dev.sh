#!/usr/bin/env bash
PROJECTS_DIR="$HOME/dev"
DOCUMENTS_DIR="$HOME/Documents"

# Format: "name:base_dir"
PRIORITY_PROJECTS=(
  "Tasks:$DOCUMENTS_DIR"
  "Academia:$DOCUMENTS_DIR"
  "Study:$DOCUMENTS_DIR"
  "zettelkasten:$DOCUMENTS_DIR"
)

if [ ! -d "$PROJECTS_DIR" ]; then
  notify-send "Error" "Projects directory not found: $PROJECTS_DIR"
  exit 1
fi

priority_names=()
priority_list=""
for entry in "${PRIORITY_PROJECTS[@]}"; do
  proj="${entry%%:*}"
  base="${entry##*:}"
  if [ -d "$base/$proj" ]; then
    priority_list+="$proj"$'\n'
    priority_names+=("$proj")
  fi
done

regular_projects=$(find "$PROJECTS_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort | grep -vxF "$(printf '%s\n' "${priority_names[@]}")")
projects="${priority_list}${regular_projects}"

selected=$(echo "$projects" | rofi -dmenu -i -p "" -theme-str "element { children: [element-text]; } element-text { padding: 0 0 0 10px; }")

if [ -n "$selected" ]; then
  # Look up the base dir from priority list first
  target_dir=""
  for entry in "${PRIORITY_PROJECTS[@]}"; do
    proj="${entry%%:*}"
    base="${entry##*:}"
    if [ "$proj" = "$selected" ]; then
      target_dir="$base/$selected"
      break
    fi
  done
  # Fall back to PROJECTS_DIR for regular projects
  if [ -z "$target_dir" ]; then
    target_dir="$PROJECTS_DIR/$selected"
  fi

  kitty --directory "$target_dir" tmux new-session -A -s "$selected" &
fi
