#!/bin/bash

while true; do
    nvtop
    echo "nvtop exited, restarting in 5 seconds..."
    sleep 5
done
