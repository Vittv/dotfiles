#!/bin/bash

# Hyprland Wallpaper Switcher with Image Preview
# Dependencies: rofi, imagemagick (for thumbnails)

WALLPAPER_DIR="$HOME/Pictures/pictures/pics/hyprland/hyprpaper"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"
CACHE_DIR="$HOME/.cache/wallpaper-switcher"

# Create cache directory for thumbnails
mkdir -p "$CACHE_DIR"

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper Switcher" "Wallpaper directory not found!" -u critical
    exit 1
fi

# Get all image files
cd "$WALLPAPER_DIR" || exit 1

# Set nullglob to avoid literal strings when no matches
shopt -s nullglob
VALID_WALLPAPERS=(*.jpg *.jpeg *.png *.webp *.JPG *.JPEG *.PNG *.WEBP)
shopt -u nullglob

# Check if any wallpapers found
if [ ${#VALID_WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Wallpaper Switcher" "No wallpapers found!" -u critical
    exit 1
fi

# Generate thumbnails and rofi menu entries
MENU_ENTRIES=""
for wallpaper in "${VALID_WALLPAPERS[@]}"; do
    THUMB="$CACHE_DIR/${wallpaper}.thumb.png"
    
    # Generate thumbnail if it doesn't exist or is older than original
    if [ ! -f "$THUMB" ] || [ "$WALLPAPER_DIR/$wallpaper" -nt "$THUMB" ]; then
        convert "$WALLPAPER_DIR/$wallpaper" -resize 200x200^ -gravity center -extent 200x200 "$THUMB" 2>/dev/null
    fi
    
    # Add to menu with thumbnail
    MENU_ENTRIES="${MENU_ENTRIES}${wallpaper}\x00icon\x1f${THUMB}\n"
done

# Show rofi with image previews
SELECTED=$(echo -en "$MENU_ENTRIES" | rofi -dmenu \
    -i \
    -p "Select Wallpaper" \
    -theme-str 'window {location: center; anchor: center; width: 1100px; height: 85%;}' \
    -theme-str 'listview {columns: 3; scrollbar: true; spacing: 10px; flow: horizontal;}' \
    -theme-str 'element {padding: 10px; orientation: vertical; border-radius: 8px;}' \
    -theme-str 'element-icon {size: 180px; border-radius: 8px;}' \
    -theme-str 'element-text {horizontal-align: 0.5; margin: 5px 0 0 0;}' \
    -show-icons)

# Exit if nothing selected
if [ -z "$SELECTED" ]; then
    exit 0
fi

# Full path to selected wallpaper (using ~/ for hyprpaper compatibility)
WALLPAPER_PATH="~/Pictures/pictures/pics/hyprland/hyprpaper/$SELECTED"

# Write new hyprpaper config (matching your exact format)
cat > "$CONFIG_FILE" << EOF
preload = $WALLPAPER_PATH
wallpaper = , $WALLPAPER_PATH
EOF

# Update hyprlock config - replace the path line in the background section
sed -i "s|path = .*|path = $WALLPAPER_PATH|g" "$HYPRLOCK_CONFIG"

# Restart hyprpaper
killall hyprpaper 2>/dev/null
sleep 0.2
hyprpaper &
disown

# Send notification with preview
notify-send "Wallpaper Changed" "Applied: $SELECTED" -i "$WALLPAPER_DIR/$SELECTED"
