#!/bin/bash
set -euo pipefail

MIN_TEMP=2000
MAX_TEMP=6500
STEP=500
DEFAULT_TEMP=5000

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
STATE_FILE="$STATE_DIR/redshift_temp"
LOG_FILE="$STATE_DIR/redshift_temp.log"
mkdir -p "$STATE_DIR"

# Create state file if missing
if [ ! -f "$STATE_FILE" ]; then
  echo "$DEFAULT_TEMP" > "$STATE_FILE"
fi

CUR_TEMP=$(<"$STATE_FILE")

case "${1:-}" in
  up)     NEW_TEMP=$((CUR_TEMP + STEP)) ;;
  down)   NEW_TEMP=$((CUR_TEMP - STEP)) ;;
  reset)  NEW_TEMP=$MAX_TEMP ;;
  apply)  NEW_TEMP=$CUR_TEMP ;;
  *)
    echo "Usage: $0 {up|down|reset|apply}"
    exit 1
    ;;
esac

# Clamp
(( NEW_TEMP > MAX_TEMP )) && NEW_TEMP=$MAX_TEMP
(( NEW_TEMP < MIN_TEMP )) && NEW_TEMP=$MIN_TEMP

REDSHIFT_BIN="$(command -v redshift || true)"
if [ -z "$REDSHIFT_BIN" ]; then
  echo "$(date -Is) ERROR: redshift not found in PATH" >> "$LOG_FILE"
  exit 1
fi

# Try a few times (helps if i3 runs this very early during login)
ok=0
for i in 1 2 3 4 5; do
  if "$REDSHIFT_BIN" -P -O "$NEW_TEMP" >>"$LOG_FILE" 2>&1; then
    ok=1
    break
  fi
  sleep 0.5
done

echo "$(date -Is) cmd=${1:-} cur=$CUR_TEMP new=$NEW_TEMP ok=$ok display=${DISPLAY:-unset}" >> "$LOG_FILE"

# Save state (even if apply)
echo "$NEW_TEMP" > "$STATE_FILE"

# If redshift failed after retries, return non-zero
[ "$ok" -eq 1 ]
