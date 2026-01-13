#!/bin/bash

FOCUSED_OUTPUT=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).output')

echo "$FOCUSED_OUTPUT"

if [ "$FOCUSED_OUTPUT" = "HDMI-1" ] || [ "$FOCUSED_OUTPUT" = "DP-3" ]; then
  alacritty --config-file ~/.config/alacritty/highdpi.toml
else
  alacritty
fi

