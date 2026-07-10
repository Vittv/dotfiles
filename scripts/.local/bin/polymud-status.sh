#!/usr/bin/env bash
if pgrep -u root mudrun-headless > /dev/null 2>&1; then
  echo "%{F#6e94b2} 󰱓 ON "
else
  echo "%{F#7e98e8}󰲛 OFF"
fi
