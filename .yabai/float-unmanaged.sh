#!/bin/bash

WIN_ID="$YABAI_WINDOW_ID"

IS_MANAGED=$(yabai -m query --windows --window "$WIN_ID" | jq -r '.["is-managed"]')
IS_FLOATING=$(yabai -m query --windows --window "$WIN_ID" | jq -r '.["is-floating"]')
echo "IS_MANAGED: $IS_MANAGED, IS_FLOATING: $IS_FLOATING"
if [ "$IS_MANAGED" = "false" ] && [ "$IS_FLOATING" = "false" ]; then
  yabai -m window "$WIN_ID" --toggle float
fi