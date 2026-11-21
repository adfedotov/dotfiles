# dotfiles

Each top-level folder mirrors `$HOME` and is installed with [GNU Stow](https://www.gnu.org/software/stow/).

| Folder   | Contents                                  |
| -------- | ----------------------------------------- |
| `common` | Shared across OSes: nvim, tmux, kitty, starship |
| `macos`  | aerospace, sketchybar, `Brewfile`         |
| `linux`  | hyprland, waybar, fuzzel, gtk, zsh (Arch) |
| `system` | Not stowed: files outside `$HOME`, installed by their own script (see each folder's README) |

## Install

```sh
# macOS
brew bundle --file=macos/Brewfile
stow common macos

# Linux
stow common linux
system/sddm/install.sh --preset bright ~/Pictures/wallpapers/<wallpaper>   # login screen, see system/sddm/README.md
```

Existing files in `$HOME` must be moved aside first, or Stow will refuse to overwrite them.
