#!/bin/bash

WIN_ID="$YABAI_WINDOW_ID"

WIN_JSON=$(yabai -m query --windows --window "$WIN_ID")
IS_MANAGED=$(echo "$WIN_JSON" | jq -r '.["is-managed"]')
IS_FLOATING=$(echo "$WIN_JSON" | jq -r '.["is-floating"]')

if [ "$IS_MANAGED" = "false" ] && [ "$IS_FLOATING" = "false" ]; then
  yabai -m window "$WIN_ID" --toggle float
fi
