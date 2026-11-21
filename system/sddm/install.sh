#!/usr/bin/env bash
# Install (or preview) the Pantheon SDDM theme with a host-specific wallpaper.
#
#   ./install.sh [--preset bright|dark] [--preview] [--screenshot PATH] <wallpaper>
#
# --preview      run SDDM's test greeter instead of installing (no sudo)
# --screenshot   with --preview: save PATH-<width>.png of each screen, then exit
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
theme=pantheon
preset=bright
preview=false
shot=""
wallpaper=""

usage() { sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

while [[ $# -gt 0 ]]; do
  case $1 in
    --preset)     preset=$2; shift 2 ;;
    --preview)    preview=true; shift ;;
    --screenshot) shot=$2; shift 2 ;;
    -h|--help)    usage ;;
    -*)           echo "unknown option: $1" >&2; usage 1 ;;
    *)            wallpaper=$1; shift ;;
  esac
done

[[ -n $wallpaper ]] || { echo "error: no wallpaper given" >&2; usage 1; }
[[ -f $wallpaper ]] || { echo "error: not a file: $wallpaper" >&2; exit 1; }
[[ -f $here/presets/$preset.conf ]] || { echo "error: no preset '$preset' (have: $(ls "$here/presets" | sed 's/\.conf$//' | xargs))" >&2; exit 1; }

# --- stage the theme ---
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
cp -r "$here/$theme" "$stage/$theme"

ext=${wallpaper##*.}; ext=${ext,,}
cp "$wallpaper" "$stage/$theme/background.$ext"

{
  echo "[General]"
  echo "background=background.$ext"
  grep -v -E '^\s*(#|$)' "$here/presets/$preset.conf"
  if $preview; then
    # the test greeter stacks every screen's window on one monitor, so show the form everywhere
    echo "formScreen=all"
    [[ -n $shot ]] && echo "screenshot=$shot"
  fi
} > "$stage/$theme/theme.conf.user"

# --- preview ---
if $preview; then
  if [[ -n $shot ]]; then
    timeout 5 sddm-greeter-qt6 --test-mode --theme "$stage/$theme" >/dev/null 2>&1 || true
    ls "$shot"-*.png
  else
    echo "Previewing (close the window to exit)…"
    sddm-greeter-qt6 --test-mode --theme "$stage/$theme" >/dev/null 2>&1 || true
  fi
  exit 0
fi

# --- install ---
dest=/usr/share/sddm/themes/$theme
echo "Installing to $dest (preset: $preset, wallpaper: $wallpaper)"
chmod -R a+rX "$stage/$theme"
sudo rm -rf "$dest"
sudo cp -r "$stage/$theme" "$dest"
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=%s\n' "$theme" | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null
echo "Done. You'll see it at the next login."
