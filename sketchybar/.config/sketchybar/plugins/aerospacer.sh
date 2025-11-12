#!/usr/bin/env bash

id="${NAME#space.}"

if [ "$id" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" background.drawing=on
else
  sketchybar --set "$NAME" background.drawing=off
fi
