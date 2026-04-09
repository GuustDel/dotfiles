#!/bin/bash

FOCUSED_OUTPUT=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).output')

case "$FOCUSED_OUTPUT" in
  HDMI-1|DP-3|DP-1)
    exec kitty -o font_size=10.0 -o background_opacity=0.8
    ;;
  *)
    exec kitty -o font_size=13.0 -o background_opacity=0.8
    ;;
esac
