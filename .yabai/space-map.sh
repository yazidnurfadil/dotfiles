#!/bin/bash

ACTION="$1"   # focus | move
INPUT="$2"    # 1–10

DISPLAY_COUNT=$(yabai -m query --displays | jq 'length')

# Default: identity mapping
TARGET="$INPUT"

if [ "$DISPLAY_COUNT" -gt 1 ]; then
  # External monitor attached
  case "$INPUT" in
    6) TARGET=11 ;;
    7) TARGET=12 ;;
    8) TARGET=13 ;;
    9) TARGET=14 ;;
    0) TARGET=15 ;;
  esac
fi

# Convert 0 → 10 (normal mode)
if [ "$DISPLAY_COUNT" -eq 1 ] && [ "$INPUT" = "0" ]; then
  TARGET=10
fi

# Execute action
if [ "$ACTION" = "focus" ]; then
  yabai -m space --focus "$TARGET"
elif [ "$ACTION" = "move" ]; then
  yabai -m window --space "$TARGET"
fi