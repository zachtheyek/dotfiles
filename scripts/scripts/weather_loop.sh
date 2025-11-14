#!/bin/bash

while true; do
    echo "Hourly Weather Report: $(date '+%a %b %d %Y, %H:%M:%S (UTC%z)' | sed 's/+\([0-9]\{2\}\)[0-9]\{2\}/+\1/' | sed 's/-\([0-9]\{2\}\)[0-9]\{2\}/-\1/')"

    # Retry logic for curl
    max_retries=5
    retry_count=0
    while [ $retry_count -lt $max_retries ]; do
        if curl v2d.wttr.in/Kuala-Lumpur; then
            break
        else
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                # echo "Curl failed, retrying in 1 minute..."
                sleep 60  # seconds
            else
                echo "Curl failed after $max_retries attempts"
            fi
        fi
    done

    # Calculate seconds until the next hour
    current_seconds=$(date +%s)
    seconds_past_hour=$((current_seconds % 3600))
    seconds_until_next_hour=$((3600 - seconds_past_hour))

    sleep $seconds_until_next_hour
    clear
done
