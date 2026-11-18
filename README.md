# dotfiles

Personal configuration for macOS and Arch Linux. Each top-level folder mirrors `$HOME` and is installed with [GNU Stow](https://www.gnu.org/software/stow/).

| Folder   | Contents                                  |
| -------- | ----------------------------------------- |
| `common` | Shared across OSes: nvim, tmux            |
| `macos`  | aerospace, sketchybar, `Brewfile`         |
| `linux`  | hyprland, waybar (Arch)                   |

## What's included

### common

- **Neovim** (`common/.config/nvim`): lazy.nvim plugin layout.
  - `lua/config/`: options, keymaps, autocmds, lazy bootstrap.
  - `lua/plugins/`: LSP (mason + nvim-lspconfig), completion (blink.cmp), formatting (conform), treesitter, DAP, editor tools (nvim-tree, telescope) and UI (lualine, which-key).
  - LSP servers installed via Mason: `ts_ls`, `eslint`, `html`, `cssls`, `tailwindcss`, `jsonls`, `basedpyright`, `ruff`, `lua_ls`. Formatters and debug adapters: `prettierd`, `stylua`, `debugpy`, `js-debug-adapter`.
- **tmux** (`common/.tmux.conf`): prefix is `C-a`, mouse enabled, windows and panes start at 1, 50k scrollback, Nord-style status bar. Plugins managed by [tpm](https://github.com/tmux-plugins/tpm) (`tmux-resurrect`).

### macos

- **AeroSpace**: tiling window manager (`.config/aerospace/aerospace.toml`).
- **SketchyBar**: status bar with plugin scripts in `.config/sketchybar/plugins/`.
- **Brewfile**: CLI tools, apps, fonts and languages.

### linux

- **Hyprland** (`.config/hypr/`): `hyprland.lua`, plus `hypridle`, `hyprlock` and `hyprsunset` configs.
- **Waybar** (`.config/waybar/`): `config.jsonc` and `style.css`.

## Install

Clone the repo (anywhere) and run Stow from its root. `.stowrc` sets the target to `$HOME` and keeps `Brewfile` and `README.md` from being linked.

```sh
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# macOS
brew bundle --file=macos/Brewfile
stow common macos

# Linux
stow common linux
```

Existing files in `$HOME` must be moved aside first, or Stow will refuse to overwrite them.

### Post-install

1. **tmux plugins**: install tpm, then press `prefix` + `I` inside tmux.
   ```sh
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```
2. **Neovim**: launch `nvim`. lazy.nvim installs plugins on first run, and Mason installs the LSP servers and tools listed above.
3. **Fonts** (Linux): install a Nerd Font such as Hack Nerd Font. The Brewfile installs it on macOS.

## Updating

```sh
git pull
stow -R common macos   # or: stow -R common linux
```

## Uninstall

```sh
stow -D common macos   # or: stow -D common linux
```
