#!/bin/bash
# Hyprland Wallpaper Switcher with Directory Navigation and Image Preview
# Dependencies: rofi, imagemagick (for thumbnails)
WALLPAPER_BASE="$HOME/Pictures/pictures/pics/hyprland/hyprpaper"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"
CACHE_DIR="$HOME/.cache/wallpaper-switcher"

# Create cache directory for thumbnails
mkdir -p "$CACHE_DIR"

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_BASE" ]; then
    notify-send "Wallpaper Switcher" "Wallpaper directory not found!" -u critical
    exit 1
fi

# Function to show directory tree navigator
show_directory_tree() {
    local CURRENT_DIR="${1:-$WALLPAPER_BASE}"
    
    # Build a tree of directories
    cd "$WALLPAPER_BASE" || exit 1
    
    # Get all directories recursively
    TREE_ENTRIES=""
    
    # Add option to go to base directory
    TREE_ENTRIES=" ./\n"
    
    # Find all directories, excluding .sys
    while IFS= read -r dir; do
        # Calculate depth for indentation
        REL_PATH="${dir#./}"
        if [ "$REL_PATH" = "." ]; then
            continue
        fi
        
        DEPTH=$(echo "$REL_PATH" | tr -cd '/' | wc -c)
        INDENT=$(printf '%*s' $((DEPTH * 2)) '')
        DIR_NAME=$(basename "$dir")
        
        TREE_ENTRIES="${TREE_ENTRIES}${INDENT}   ${REL_PATH}\n"
    done < <(find . -type d ! -path "*/.sys*" | sort)
    
    # Show tree in rofi
    SELECTED=$(echo -en "$TREE_ENTRIES" | rofi -dmenu \
        -i \
        -p "Select Directory" \
        -theme-str "window {location: center; anchor: center; width: 400px;} element { children: [element-text]; } element-text { padding: 0 0 0 10px; }" \
        -theme-str 'listview {columns: 1;}')
    
    if [ -z "$SELECTED" ]; then
        return 1
    fi
    
    # Extract the path from selection
    if [[ "$SELECTED" == *"(root)"* ]]; then
        echo "$WALLPAPER_BASE"
    else
        # Remove emoji and leading spaces
        DIR_PATH=$(echo "$SELECTED" | sed -E 's/^[[:space:]]+//' | sed -E 's/^[[:space:]]*//')
        # DIR_PATH=$(echo "$SELECTED" | sed 's/^[[:space:]]* //')
        echo "$WALLPAPER_BASE/$DIR_PATH"
    fi
}

# Function to show wallpaper menu for a directory
show_wallpaper_menu() {
    local CURRENT_DIR="$1"
    
    cd "$CURRENT_DIR" || exit 1
    
    # Set nullglob to avoid literal strings when no matches
    shopt -s nullglob
    
    # Get image files only (no directories in this view)
    VALID_WALLPAPERS=(*.jpg *.jpeg *.png *.webp *.JPG *.JPEG *.PNG *.WEBP)
    
    shopt -u nullglob
    
    # Check if any wallpapers found
    if [ ${#VALID_WALLPAPERS[@]} -eq 0 ]; then
        notify-send "Wallpaper Switcher" "No wallpapers found in this directory!" -u normal
        return 1
    fi
    
    # Generate menu entries
    MENU_ENTRIES=""
    
    # Add wallpapers with thumbnails
    for wallpaper in "${VALID_WALLPAPERS[@]}"; do
        THUMB="$CACHE_DIR/${wallpaper}.thumb.png"
        
        # Generate thumbnail if it doesn't exist or is older than original
        if [ ! -f "$THUMB" ] || [ "$CURRENT_DIR/$wallpaper" -nt "$THUMB" ]; then
            convert "$CURRENT_DIR/$wallpaper" -resize 200x200^ -gravity center -extent 200x200 "$THUMB" 2>/dev/null
        fi
        
        # Add to menu with thumbnail
        MENU_ENTRIES="${MENU_ENTRIES}${wallpaper}\x00icon\x1f${THUMB}\n"
    done
    
    # Show rofi with image previews
    SELECTED=$(echo -en "$MENU_ENTRIES" | rofi -dmenu \
        -i \
        -p "󰍉 " \
        -theme-str 'window {location: center; anchor: center; width: 1100px;}' \
        -theme-str 'listview {columns: 5; scrollbar: true; spacing: 10px; flow: horizontal; lines: 2;}' \
        -theme-str 'element {padding: 10px; orientation: vertical; border-radius: 8px;}' \
        -theme-str 'element-icon {size: 180px; border-radius: 8px;}' \
        -theme-str 'element-text {horizontal-align: 0.5; margin: 5px 0 0 0;}' \
        -show-icons)
    
    EXIT_CODE=$?
    
    # Check if custom keybind was pressed
    if [ $EXIT_CODE -eq 10 ]; then
        # Show directory tree
        NEW_DIR=$(show_directory_tree "$CURRENT_DIR")
        if [ -n "$NEW_DIR" ] && [ -d "$NEW_DIR" ]; then
            show_wallpaper_menu "$NEW_DIR"
        else
            show_wallpaper_menu "$CURRENT_DIR"
        fi
        return $?
    fi
    
    # Exit if nothing selected
    if [ -z "$SELECTED" ]; then
        return 1
    fi
    
    # A wallpaper was selected
    apply_wallpaper "$CURRENT_DIR" "$SELECTED"
    return $?
}

# Function to apply the selected wallpaper
apply_wallpaper() {
    local DIR="$1"
    local WALLPAPER="$2"
    
    # Get relative path from base
    local REL_PATH="${DIR#$WALLPAPER_BASE}"
    REL_PATH="${REL_PATH#/}"  # Remove leading slash if present
    
    # Full path to selected wallpaper (using ~/ for hyprpaper compatibility)
    if [ -n "$REL_PATH" ]; then
        WALLPAPER_PATH="~/Pictures/pictures/pics/hyprland/hyprpaper/$REL_PATH/$WALLPAPER"
    else
        WALLPAPER_PATH="~/Pictures/pictures/pics/hyprland/hyprpaper/$WALLPAPER"
    fi
    
    # Write new hyprpaper config
    cat > "$CONFIG_FILE" << EOF
splash = false
wallpaper {
  monitor = DP-1
  path = $WALLPAPER_PATH
  fit_mode = cover
}
wallpaper {
  monitor = HDMI-A-1
  path = $WALLPAPER_PATH
  fit_mode = cover
}
EOF
    
    # Update hyprlock config - replace the path line in the background section
    sed -i "s|path = .*|path = $WALLPAPER_PATH|g" "$HYPRLOCK_CONFIG"
    
    # Restart hyprpaper
    killall hyprpaper 2>/dev/null
    hyprpaper &
    disown
    
    # Send notification with preview
    notify-send "Wallpaper Changed" "Applied: $WALLPAPER" -i "$DIR/$WALLPAPER"
    
    return 0
}

# Start the menu from the base directory
show_wallpaper_menu "$WALLPAPER_BASE"
