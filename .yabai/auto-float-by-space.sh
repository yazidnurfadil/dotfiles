#!/bin/bash

SPACE_INDEX=$(yabai -m query --spaces --space | jq '.index')
WINDOW_JSON=$(yabai -m query --windows --window)

WINDOW_ID=$(echo "$WINDOW_JSON" | jq '.id')
IS_FLOATING=$(echo "$WINDOW_JSON" | jq '.["is-floating"]')

FLOAT_SPACES=(5 10)

should_float=false
for s in "${FLOAT_SPACES[@]}"; do
  if [ "$SPACE_INDEX" -eq "$s" ]; then
    should_float=true
    break
  fi
done

if $should_float && [ "$IS_FLOATING" = "false" ]; then
  yabai -m window "$WINDOW_ID" --toggle float
elif ! $should_float && [ "$IS_FLOATING" = "true" ]; then
  yabai -m window "$WINDOW_ID" --toggle float
fi
