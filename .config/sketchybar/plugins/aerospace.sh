#!/usr/bin/env bash

# The $1 variable holds the workspace name (passed from sketchybarrc)
# The $FOCUSED_WORKSPACE variable is passed from aerospace.toml
DATA=$(aerospace list-workspaces --all --format '%{workspace} %{monitor-id} %{workspace-is-focused}')  
FOCUSED=$(echo "$DATA" | grep 'true$' | awk '{print $1}')
VISIBLE_MONITOR=$(echo "$DATA" | grep "^$1 " | awk '{print $2}')

# Fallback: If for some reason we can't find the monitor, default to 1 to prevent disappearing
if [ -z "$VISIBLE_MONITOR" ]; then VISIBLE_MONITOR=1; fi

#    We assume the item should be transparent (drawing=off) unless it is focused
if [ "$1" = "$FOCUSED" ]; then
    ARGS="background.drawing=on background.color=0xffffffff icon.color=0xff000000"
else
    ARGS="background.drawing=off icon.color=0xffffffff"
fi

sketchybar --set $NAME display=$VISIBLE_MONITOR $ARGS
