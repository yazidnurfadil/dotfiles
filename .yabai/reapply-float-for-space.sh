#!/bin/bash

SPACE_INDEX=$(yabai -m query --spaces --space | jq '.index')

# Float spaces: 5 + either 10 (single) or 15 (external)
DISPLAY_COUNT=$(yabai -m query --displays | jq 'length')
FLOAT_SPACES=(5)
if [ "$DISPLAY_COUNT" -gt 1 ]; then
  FLOAT_SPACES+=(15)
else
  FLOAT_SPACES+=(10)
fi

should_float=false
for s in "${FLOAT_SPACES[@]}"; do
  [ "$SPACE_INDEX" -eq "$s" ] && should_float=true
done

MANUAL_FILE=/tmp/yabai_manual_float

yabai -m query --windows --space | jq -c '.[]' | while read w; do
  ID=$(echo "$w" | jq '.id')
  IS_MANAGED=$(echo "$w" | jq '.["is-managed"]')
  IS_FLOAT=$(echo "$w" | jq '.["is-floating"]')

  # Skip unmanaged windows
  [ "$IS_MANAGED" = "false" ] && continue

  # Skip manually-floated windows
  if [ -f "$MANUAL_FILE" ] && grep -qx "$ID" "$MANUAL_FILE"; then
    continue
  fi

  if $should_float && [ "$IS_FLOAT" = "false" ]; then
    yabai -m window "$ID" --toggle float
  elif ! $should_float && [ "$IS_FLOAT" = "true" ]; then
    yabai -m window "$ID" --toggle float
  fi
done
