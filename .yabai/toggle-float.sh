#!/bin/bash

WID=$(yabai -m query --windows --window | jq '.id')
FILE=/tmp/yabai_manual_float
touch "$FILE"

if grep -qx "$WID" "$FILE"; then
  sed -i '' "/^$WID$/d" "$FILE"
else
  echo "$WID" >> "$FILE"
fi

yabai -m window --toggle float
