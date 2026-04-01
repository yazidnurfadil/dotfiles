#!/bin/bash

sleep 0.8  # let macOS settle

STATE_FILE="/tmp/yabai_display_mode"

DISPLAY_COUNT=$(yabai -m query --displays | jq 'length')

# Determine current mode
if [ "$DISPLAY_COUNT" -gt 1 ]; then
  CURRENT_MODE="external"
else
  CURRENT_MODE="single"
fi

# Read previous mode
if [ -f "$STATE_FILE" ]; then
  PREV_MODE=$(cat "$STATE_FILE")
else
  PREV_MODE="unknown"
fi

# If no change → exit immediately
if [ "$CURRENT_MODE" = "$PREV_MODE" ]; then
  exit 0
fi

# Save new state
echo "$CURRENT_MODE" > "$STATE_FILE"

########################################
# Helper function
########################################
move_space() {
  FROM=$1
  TO=$2

  WINDOWS=$(yabai -m query --windows --space "$FROM" 2>/dev/null | jq 'length')

  [ "$WINDOWS" -eq 0 ] && return

  yabai -m query --windows --space "$FROM" | jq -r '.[].id' | while read id; do
    yabai -m window "$id" --space "$TO"
  done
}

########################################
# Apply shift
########################################

if [ "$CURRENT_MODE" = "external" ]; then
  echo "Switching to EXTERNAL mode"

  move_space 10 15
  move_space 9 14
  move_space 8 13
  move_space 7 12
  move_space 6 11

else
  echo "Switching to SINGLE mode"

  move_space 11 6
  move_space 12 7
  move_space 13 8
  move_space 14 9
  move_space 15 10
fi