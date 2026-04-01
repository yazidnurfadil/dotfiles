#!/bin/bash

SPACE_INDEX=$(yabai -m query --spaces --space | jq '.index')
WINDOW_JSON=$(yabai -m query --windows --window)

WINDOW_ID=$(echo "$WINDOW_JSON" | jq '.id')
IS_MANAGED=$(echo "$WINDOW_JSON" | jq '.["is-managed"]')
IS_FLOATING=$(echo "$WINDOW_JSON" | jq '.["is-floating"]')

# Skip unmanaged windows
[ "$IS_MANAGED" = "false" ] && exit 0

# Skip manually-floated windows
MANUAL_FILE=/tmp/yabai_manual_float
if [ -f "$MANUAL_FILE" ] && grep -qx "$WINDOW_ID" "$MANUAL_FILE"; then
  exit 0
fi

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
