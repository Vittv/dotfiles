#!/usr/bin/env bash

# check if the default source is muted
# returns "yes" or "no"
MUTED=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

if [ "$MUTED" = "yes" ]; then
  echo ""
else
  echo ""
fi
