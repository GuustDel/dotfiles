#!/bin/bash

LOW_NOTIFIED=0
CRIT_NOTIFIED=0

while true; do
  BAT=$(acpi -b | awk '{print $4}' | tr -d ',%')
  STATUS=$(acpi -b | awk '{print $3}' | tr -d ',')

  if [ "$STATUS" = "Discharging" ]; then
    if [ "$BAT" -le 10 ] && [ $CRIT_NOTIFIED -eq 0 ]; then
      notify-send -u critical "Battery critical" "Battery at ${BAT}%"
      CRIT_NOTIFIED=1
    elif [ "$BAT" -le 20 ] && [ $LOW_NOTIFIED -eq 0 ]; then
      notify-send -u normal "Battery low" "Battery at ${BAT}%"
      LOW_NOTIFIED=1
    fi
  else
    LOW_NOTIFIED=0
    CRIT_NOTIFIED=0
  fi

  sleep 60
done
