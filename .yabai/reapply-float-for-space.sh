#!/bin/bash

SPACE_INDEX=$(yabai -m query --spaces --space | jq '.index')
FLOAT_SPACES=(5 10)

should_float=false
for s in "${FLOAT_SPACES[@]}"; do
  [ "$SPACE_INDEX" -eq "$s" ] && should_float=true
done

yabai -m query --windows --space | jq -c '.[]' | while read w; do
  ID=$(echo "$w" | jq '.id')
  IS_FLOAT=$(echo "$w" | jq '.["is-floating"]')

  if $should_float && [ "$IS_FLOAT" = "false" ]; then
    yabai -m window "$ID" --toggle float
  elif ! $should_float && [ "$IS_FLOAT" = "true" ]; then
    yabai -m window "$ID" --toggle float
  fi
done
