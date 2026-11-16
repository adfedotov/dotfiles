# dotfiles

Each top-level folder mirrors `$HOME` and is installed with [GNU Stow](https://www.gnu.org/software/stow/).

| Folder   | Contents                                  |
| -------- | ----------------------------------------- |
| `common` | Shared across OSes: nvim, tmux            |
| `macos`  | aerospace, sketchybar, `Brewfile`         |
| `linux`  | hyprland, waybar (Arch)                   |

## Install

```sh
# macOS
brew bundle --file=macos/Brewfile
stow common macos

# Linux
stow common linux
```

Existing files in `$HOME` must be moved aside first, or Stow will refuse to overwrite them.
