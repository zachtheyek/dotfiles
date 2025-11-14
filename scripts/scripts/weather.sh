#!/bin/bash

while true; do
    echo "Hourly Weather Report: $(date)"
    curl wttr.in/Kuala-Lumpur

    # Calculate seconds until the next hour
    current_seconds=$(date +%s)
    seconds_past_hour=$((current_seconds % 3600))
    seconds_until_next_hour=$((3600 - seconds_past_hour))

    sleep $seconds_until_next_hour
    clear
done
