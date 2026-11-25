#!/usr/bin/env bash
# Night light control for hyprsunset (keeps running for the schedule in hyprsunset.conf).
#   nightlight.sh toggle   flip warm/normal right now (manual override)
#   nightlight.sh status   JSON for waybar
#
# hyprsunset can't report whether it's in identity mode, so we track it:
# the schedule decides, unless the user toggled after the most recent schedule change.

TEMP=4000          # keep in sync with hyprsunset.conf
ON_AT=2000         # 20:00
OFF_AT=0730        # 07:30
STATE=${XDG_RUNTIME_DIR:-/tmp}/nightlight.override   # contains on|off, mtime = when toggled

hm() { date -d "@$1" +%H%M; }

# epoch of the most recent schedule boundary, and the state it set
schedule() {
  local now=$(date +%s) today=$(date +%F)
  local on=$(date -d "$today ${ON_AT:0:2}:${ON_AT:2}" +%s)
  local off=$(date -d "$today ${OFF_AT:0:2}:${OFF_AT:2}" +%s)
  if   (( now >= on ));  then echo "$on on"
  elif (( now >= off )); then echo "$off off"
  else echo "$(( on - 86400 )) on"; fi
}

current() {
  read -r since sched < <(schedule)
  if [[ -f $STATE ]] && (( $(stat -c %Y "$STATE") >= since )); then
    cat "$STATE"
  else
    echo "$sched"
  fi
}

case ${1:-status} in
  toggle)
    if [[ $(current) == on ]]; then
      hyprctl hyprsunset identity >/dev/null && echo off > "$STATE"
    else
      hyprctl hyprsunset temperature "$TEMP" >/dev/null && echo on > "$STATE"
    fi
    pkill -RTMIN+8 waybar   # refresh the module now
    ;;
  status)
    if ! pgrep -x hyprsunset >/dev/null; then
      printf '{"text":"","class":"off","tooltip":"Night light: hyprsunset not running"}\n'
    elif [[ $(current) == on ]]; then
      printf '{"text":"","class":"on","tooltip":"Night light: on (%sK)\\nScheduled %s–%s"}\n' "$TEMP" "${ON_AT:0:2}:${ON_AT:2}" "${OFF_AT:0:2}:${OFF_AT:2}"
    else
      printf '{"text":"","class":"off","tooltip":"Night light: off\\nScheduled %s–%s"}\n' "${ON_AT:0:2}:${ON_AT:2}" "${OFF_AT:0:2}:${OFF_AT:2}"
    fi
    ;;
esac
