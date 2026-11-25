#!/bin/sh
# Toggle mako's do-not-disturb mode and confirm with a short notification
# (app-name mako-dnd is whitelisted in config so it shows even while DND is on).
makoctl mode -t do-not-disturb >/dev/null
if makoctl mode | grep -qx do-not-disturb; then
  notify-send -a mako-dnd -t 1500 "󰂛  Do not disturb" "on"
else
  notify-send -a mako-dnd -t 1500 "󰂚  Do not disturb" "off"
fi
