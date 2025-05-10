#!/bin/bash

# Hardcoded display output (based on your test)
OUTPUT="eDP-1"

# Gamma mappings for color temperatures (approximate)
declare -A GAMMAS=(
  [3000]="1:0.6:0.4"
  [3500]="1:0.7:0.5"
  [4000]="1:0.75:0.55"
  [4500]="1:0.8:0.6"
  [5000]="1:0.85:0.7"
  [5500]="1:0.9:0.8"
  [6000]="1:0.95:0.9"
  [6500]="1:1:1"
)

# Temp file for tracking current state
TEMP_FILE="/tmp/current_temp"
DEFAULT_TEMP=5000
STEP=500
MIN_TEMP=3000
MAX_TEMP=6500

# Initialize if needed
if [ ! -f "$TEMP_FILE" ]; then
  echo "$DEFAULT_TEMP" > "$TEMP_FILE"
fi

# Read and update temperature
CUR_TEMP=$(cat "$TEMP_FILE")

case "$1" in
  up)
    NEW_TEMP=$((CUR_TEMP + STEP))
    ;;
  down)
    NEW_TEMP=$((CUR_TEMP - STEP))
    ;;
  reset)
    NEW_TEMP=6500
    ;;
  *)
    echo "Usage: $0 {up|down|reset}"
    exit 1
    ;;
esac

# Clamp
if [ "$NEW_TEMP" -gt "$MAX_TEMP" ]; then
  NEW_TEMP=$MAX_TEMP
elif [ "$NEW_TEMP" -lt "$MIN_TEMP" ]; then
  NEW_TEMP=$MIN_TEMP
fi

# Apply gamma
GAMMA="${GAMMAS[$NEW_TEMP]}"
if [ -z "$GAMMA" ]; then
  GAMMA="1:1:1"
fi

xrandr --output "$OUTPUT" --gamma "$GAMMA"

# Save
echo "$NEW_TEMP" > "$TEMP_FILE"
