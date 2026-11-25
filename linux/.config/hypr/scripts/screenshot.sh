#!/usr/bin/env bash
# Screenshots: clipboard by default, file only when asked.
#   screenshot.sh region     select area  -> clipboard
#   screenshot.sh screen     focused monitor -> clipboard
#   screenshot.sh window     active window -> clipboard
#   screenshot.sh edit       select area  -> satty (annotate, Enter copies)
#   screenshot.sh save       select area  -> ~/Pictures/Screenshots + clipboard
set -euo pipefail

dir=${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots
tmp=${XDG_RUNTIME_DIR:-/tmp}/screenshot.png

# Nord-tinted selection
pick() { slurp -d -b 2e344066 -c 88c0d0ff -s 88c0d01a -w 2 -B 2e344033; }

focused_monitor() { hyprctl monitors | awk '/^Monitor/{m=$2} /focused: yes/{print m; exit}'; }
active_window()   { hyprctl activewindow | awk '/^\tat:/{split($2,a,",")} /^\tsize:/{split($2,b,",")} END{if(a[1]!="") printf "%s,%s %sx%s", a[1],a[2],b[1],b[2]}'; }

notify() { notify-send -a screenshot -i "$1" "$2" "$3"; }

case ${1:-region} in
  region)
    geo=$(pick) || exit 0
    grim -g "$geo" "$tmp"
    wl-copy --type image/png < "$tmp"
    notify "$tmp" "Screenshot copied" "Region" ;;
  screen)
    grim -o "$(focused_monitor)" "$tmp"
    wl-copy --type image/png < "$tmp"
    notify "$tmp" "Screenshot copied" "Screen" ;;
  window)
    geo=$(active_window); [[ -n $geo ]] || exit 0
    grim -g "$geo" "$tmp"
    wl-copy --type image/png < "$tmp"
    notify "$tmp" "Screenshot copied" "Window" ;;
  edit)
    geo=$(pick) || exit 0
    grim -g "$geo" - | satty --filename - ;;
  save)
    geo=$(pick) || exit 0
    mkdir -p "$dir"
    file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"
    grim -g "$geo" "$file"
    wl-copy --type image/png < "$file"
    notify "$file" "Screenshot saved" "${file/#$HOME/\~}  (also copied)" ;;
  *) echo "usage: $0 region|screen|window|edit|save" >&2; exit 1 ;;
esac
