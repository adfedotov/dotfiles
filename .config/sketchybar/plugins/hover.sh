#!/bin/bash

DEFAULT_COLOR=0xFF1E1E2E
HOVER_COLOR=0xFF45475A

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set $NAME background.color=$HOVER_COLOR
  
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set $NAME background.color=$DEFAULT_COLOR
fi
