#!/bin/bash

# Exit with help message if no arguments provided
if [ -z "$1" ]; then
    echo "Usage: $0 <ssh-destination>"
    echo "Example: $0 user@hostname"
    echo "         $0 my-server"
    exit 1
fi

while true; do
    ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=5 "$@"
    EXIT_CODE=$?

    # If user explicitly exited (exit 0), don't reconnect
    if [ $EXIT_CODE -eq 0 ]; then
        echo "SSH session exited normally."
        break
    fi

    echo "SSH connection closed (exit code: $EXIT_CODE), reconnecting in 5 seconds..."
    echo "Press Ctrl+C to cancel reconnection."
    sleep 5
done
