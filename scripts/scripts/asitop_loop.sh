#!/bin/bash

while true; do
    sudo asitop
    echo "asitop exited, restarting in 5 seconds..."
    echo "Press Ctrl+C to cancel restart."
    sleep 5  # seconds
    clear
done
