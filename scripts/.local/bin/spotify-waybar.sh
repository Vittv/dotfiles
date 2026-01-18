#!/bin/bash

# Customization settings
GLYPH_FONT_FAMILY="JetBrainsMono Nerd Font Propo"
GLYPH_PLAYING="󰓇"
GLYPH_PAUSED="󰏤"
GLYPH_STOPPED=""
TEXT_WHEN_STOPPED="Nothing playing right now"
SCROLL_TEXT_LENGTH=40
REFRESH_INTERVAL=0.25
PLAYERCTL_PATH="/usr/bin/playerctl"
PLAYER="spotify"

# State file to persist scroll position
STATE_FILE="/tmp/spotify-waybar-state"

# Function to escape XML/HTML characters (only & < > for Pango markup)
escape_xml() {
    local text="$1"
    text="${text//&/&amp;}"
    text="${text//</&lt;}"
    text="${text//>/&gt;}"
    echo "$text"
}

# Function to pad text to fixed length
pad_text() {
    local text="$1"
    local length="$2"
    printf "%-${length}s" "$text"
}

# Function to scroll text
scroll_text() {
    local text="$1"
    local length="$2"
    local position="$3"
    
    # Add padding and separator for scrolling
    local padded_text="${text}   ${text}"
    local max_scroll=$((${#text} + 3))
    
    # Extract substring for current scroll position
    local scrolled="${padded_text:$position:$length}"
    
    echo "$scrolled"
}

# Read state from file
if [ -f "$STATE_FILE" ]; then
    source "$STATE_FILE"
else
    scroll_position=0
    current_song=""
fi

# Main loop
while true; do
    # Get player status
    status=$($PLAYERCTL_PATH -p $PLAYER status 2>/dev/null)
    status_lower=$(echo "$status" | tr '[:upper:]' '[:lower:]')
    
    # Get current song
    song=$($PLAYERCTL_PATH -p $PLAYER metadata --format '{{ artist }} - {{ title }}' 2>/dev/null)
    
    # Get volume
    volume=$($PLAYERCTL_PATH -p $PLAYER volume 2>/dev/null)
    if [ -n "$volume" ]; then
        volume_percent=$(awk -v vol="$volume" 'BEGIN {printf "%.0f%%", vol*100}')
    else
        volume_percent=""
    fi
    
    # Reset scroll position if song changed
    if [ "$song" != "$current_song" ]; then
        scroll_position=0
        current_song="$song"
    fi
    
    # Determine glyph based on status
    case "$status_lower" in
        playing)
            glyph="$GLYPH_PLAYING"
            ;;
        paused)
            glyph="$GLYPH_PAUSED"
            ;;
        *)
            glyph="$GLYPH_STOPPED"
            ;;
    esac
    
    # Handle song text
    if [ -n "$song" ]; then
        song_length=${#song}
        # Only scroll if playing AND text is long
        if [ $song_length -gt $SCROLL_TEXT_LENGTH ] && [ "$status_lower" = "playing" ]; then
            song_text=$(scroll_text "$song" $SCROLL_TEXT_LENGTH $scroll_position)
            
            # Increment scroll position
            max_scroll=$((song_length + 3))
            scroll_position=$((scroll_position + 1))
            if [ $scroll_position -ge $max_scroll ]; then
                scroll_position=0
            fi
        else
            # When paused/stopped or text is short, show static text
            if [ $song_length -gt $SCROLL_TEXT_LENGTH ]; then
                # Show truncated text from current scroll position when paused
                song_text="${song:0:$SCROLL_TEXT_LENGTH}"
            else
                song_text=$(pad_text "$song" $SCROLL_TEXT_LENGTH)
            fi
        fi
        tooltip="$status: $song"
    else
        song_text=$(pad_text "$TEXT_WHEN_STOPPED" $SCROLL_TEXT_LENGTH)
        tooltip="Nothing playing"
        scroll_position=0
        current_song=""
    fi
    
    # Save state to file
    echo "scroll_position=$scroll_position" > "$STATE_FILE"
    echo "current_song=\"$current_song\"" >> "$STATE_FILE"
    
    # Escape special characters for XML/HTML and JSON
    song_text_escaped=$(escape_xml "$song_text")
    tooltip_escaped=$(escape_xml "$tooltip")
    
    # Further escape for JSON
    song_text_escaped=$(echo "$song_text_escaped" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
    tooltip_escaped=$(echo "$tooltip_escaped" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
    
    # Output JSON with volume
    if [ -n "$volume_percent" ]; then
        text="<span font_family='$GLYPH_FONT_FAMILY'>$glyph</span> $volume_percent $song_text_escaped"
    else
        text="<span font_family='$GLYPH_FONT_FAMILY'>$glyph</span> $song_text_escaped"
    fi
    echo "{\"text\":\"$text\",\"tooltip\":\"$tooltip_escaped\"}"
    
    sleep $REFRESH_INTERVAL
done
