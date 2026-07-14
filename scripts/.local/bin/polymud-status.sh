#!/usr/bin/env bash
if pgrep -u root mudrun-headless > /dev/null 2>&1; then
  echo "󰱓 ON "
else
  echo "󰲛 OFF"
fi
