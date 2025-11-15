#!/bin/bash

# Parse CLI args
location="Kuala-Lumpur"  # Default location
while [[ $# -gt 0 ]]; do
    case $1 in
        -l|--location)
            location="$2"
            shift 2
            ;;
        *)
            echo "Unknown flag provided: $1"
            echo "Usage: $0 [-l|--location LOCATION]"
            echo "Example: $0 -l Kuala-Lumpur"
            echo "         $0 --location Beijing"
            exit 1
            ;;
    esac
done

while true; do
    echo "Hourly Weather Report: $(date '+%a %b %d %Y, %H:%M:%S (UTC%z)' | sed 's/+\([0-9]\{2\}\)[0-9]\{2\}/+\1/' | sed 's/-\([0-9]\{2\}\)[0-9]\{2\}/-\1/')"

    # Retry loop
    max_attempts=30  # Try for 30 mins max
    num_attempts=0
    outputs=()
    while [ $num_attempts -lt $max_attempts ]; do
        num_attempts=$((num_attempts + 1))
        curl_output=$(curl v2d.wttr.in/$location 2>&1)
        # If curl was successful, print output & break retry loop
        if [ $? -eq 0 ]; then
            echo "$curl_output"
            break
        # Else add errors to list
        else
            outputs+=("Curl attempt $num_attempts/$max_attempts: $curl_output")
            # If more attempts left, sleep & try again later
            if [ $num_attempts -lt $max_attempts ]; then
                sleep 60  # seconds
            # Else give up & flush errors into stdout 
            else
                echo "Curl failed after $max_attempts attempts:"
                printf '%s\n' "${outputs[@]}"
            fi
        fi
    done

    # Calculate seconds until the next hour
    current_seconds=$(date +%s)
    seconds_past_hour=$((current_seconds % 3600))
    seconds_until_next_hour=$((3600 - seconds_past_hour))

    # Wait for next hour
    sleep $seconds_until_next_hour
    clear
done
