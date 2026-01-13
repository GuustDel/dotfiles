#!/bin/bash

# Color temperature bounds and step
MIN_TEMP=2000
MAX_TEMP=6500
STEP=500
DEFAULT_TEMP=4000
STATE_FILE="/tmp/redshift_temp"

# Ensure the state file exists
[ ! -f "$STATE_FILE" ] && echo "$DEFAULT_TEMP" > "$STATE_FILE"
CUR_TEMP=$(<"$STATE_FILE")

case "$1" in
  up)    NEW_TEMP=$((CUR_TEMP + STEP));;
  down)  NEW_TEMP=$((CUR_TEMP - STEP));;
  reset) NEW_TEMP=$MAX_TEMP;;
  *)     echo "Usage: $0 {up|down|reset}"; exit 1;;
esac

# Clamp to valid range
(( NEW_TEMP > MAX_TEMP )) && NEW_TEMP=$MAX_TEMP
(( NEW_TEMP < MIN_TEMP )) && NEW_TEMP=$MIN_TEMP

# Apply using redshift override
redshift -P -O "$NEW_TEMP"

# Save new temp
echo "$NEW_TEMP" > "$STATE_FILE"
