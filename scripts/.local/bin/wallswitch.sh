#!/usr/bin/env bash
# wallpaper switcher - Xorg (feh) and Wayland (hyprpaper + hyprlock)
# dependencies: rofi, imagemagick (for thumbnails)
WALLPAPER_BASE="$HOME/Pictures/pictures/pics/wallpapers/"
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"
CACHE_DIR="$HOME/.cache/wallpaper-switcher"

SESSION="${XDG_SESSION_TYPE:-x11}"

mkdir -p "$CACHE_DIR"

if [ ! -d "$WALLPAPER_BASE" ]; then
    notify-send "Wallpaper Switcher" "Wallpaper directory not found!" -u critical
    exit 1
fi

show_wallpaper_menu() {
    cd "$WALLPAPER_BASE" || exit 1

    shopt -s nullglob
    VALID_WALLPAPERS=(*.jpg *.jpeg *.png *.webp *.JPG *.JPEG *.PNG *.WEBP)
    shopt -u nullglob

    if [ ${#VALID_WALLPAPERS[@]} -eq 0 ]; then
        notify-send "Wallpaper Switcher" "No wallpapers found!" -u normal
        return 1
    fi

    MENU_ENTRIES=""
    for wallpaper in "${VALID_WALLPAPERS[@]}"; do
        THUMB="$CACHE_DIR/${wallpaper}.thumb.png"
        if [ ! -f "$THUMB" ] || [ "$WALLPAPER_BASE/$wallpaper" -nt "$THUMB" ]; then
            convert "$WALLPAPER_BASE/$wallpaper" -resize 200x200^ -gravity center -extent 200x200 "$THUMB" 2>/dev/null
        fi
        MENU_ENTRIES="${MENU_ENTRIES}${wallpaper}\x00icon\x1f${THUMB}\n"
    done

    SELECTED=$(echo -en "$MENU_ENTRIES" | rofi -dmenu \
        -i \
        -p "󰍉 " \
        -theme-str 'window {location: center; anchor: center; width: 1100px;}' \
        -theme-str 'listview {columns: 5; scrollbar: true; spacing: 10px; flow: horizontal; lines: 2;}' \
        -theme-str 'element {padding: 10px; orientation: vertical; border-radius: 8px;}' \
        -theme-str 'element-icon {size: 180px; border-radius: 8px;}' \
        -theme-str 'element-text {horizontal-align: 0.5; margin: 5px 0 0 0;}' \
        -show-icons)

    if [ -z "$SELECTED" ]; then
        return 1
    fi

    apply_wallpaper "$SELECTED"
    return $?
}

apply_wallpaper() {
    local WALLPAPER="$1"
    local WALLPAPER_PATH_HYPR="~/Pictures/pictures/pics/wallpapers/$WALLPAPER"
    local WALLPAPER_PATH_ABS="$WALLPAPER_BASE/$WALLPAPER"

    if [ "$SESSION" = "wayland" ]; then
        cat > "$HOME/.config/hypr/hyprpaper.conf" << EOF
splash = false
wallpaper {
  monitor = DP-1
  path = $WALLPAPER_PATH_HYPR
  fit_mode = cover
}
wallpaper {
  monitor = HDMI-A-1
  path = $WALLPAPER_PATH_HYPR
  fit_mode = cover
}
EOF
        sed -i "s|path = .*|path = $WALLPAPER_PATH_HYPR|g" "$HYPRLOCK_CONFIG"
        killall hyprpaper 2>/dev/null
        hyprpaper &
        disown
    else
        feh --bg-fill "$WALLPAPER_PATH_ABS"
    fi

    notify-send "Wallpaper Changed" "Applied: $WALLPAPER" -i "$WALLPAPER_PATH_ABS"
    return 0
}

show_wallpaper_menu
