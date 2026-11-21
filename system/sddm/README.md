# SDDM login theme (Pantheon)

A minimal, Nord-tinted login screen: big clock, username and password fields on a
frosted card, session switcher bottom-left, power buttons bottom-right. Qt6 only.

SDDM themes live in `/usr/share` and need root, so this folder is **not** stowed.
It's installed with `install.sh`, which also copies in the host's wallpaper.

```
system/sddm/
├── install.sh        # preview or install, with wallpaper + preset
├── presets/          # look tuned for bright or dark wallpapers
│   ├── bright.conf
│   └── dark.conf
└── pantheon/         # the theme (same on every host)
    ├── Main.qml
    ├── metadata.desktop
    └── theme.conf    # defaults: don't edit per host
```

## Setting up a host

Wallpapers aren't in this repo. Keep them in `~/Pictures/wallpapers/` on each machine.

1. **Pick a preset** to match the wallpaper:

   | Preset   | Use for                       | What it does                                              |
   | -------- | ----------------------------- | --------------------------------------------------------- |
   | `bright` | bright, busy, washed-out images | darkens the scene 45%, dark frosted card, shadow under the clock |
   | `dark`   | dark or moody images          | barely dims (15%), light glass card, no shadow            |

2. **Preview it** (no sudo, nothing installed):

   ```sh
   ./install.sh --preset bright --preview ~/Pictures/wallpapers/"pantheon data center.png"
   ```

   The preview shows the form on every monitor. In test mode Hyprland stacks every
   screen's window on one monitor, so the real layout only shows at the actual login.

3. **Install it:**

   ```sh
   ./install.sh --preset bright ~/Pictures/wallpapers/"pantheon data center.png"
   ```

   This copies the theme to `/usr/share/sddm/themes/pantheon`, puts the wallpaper next to
   it as `background.<ext>`, writes `theme.conf.user` (wallpaper and preset), and sets
   `Current=pantheon` in `/etc/sddm.conf.d/theme.conf`. You'll see it at the next login.

To change the wallpaper or preset later, run the install again. It replaces the
whole theme folder.

## Tweaking

SDDM reads `theme.conf`, then `theme.conf.user` on top of it. Every key can go in a
preset, and a new preset is just a new `presets/<name>.conf`.

| Key           | Default            | Meaning                                                   |
| ------------- | ------------------ | --------------------------------------------------------- |
| `dim`         | `0.45`             | darken the wallpaper: 0 = untouched, 1 = black            |
| `blur`        | `0.0`              | blur the whole wallpaper (0–1)                            |
| `accent`      | `#88c0d0`          | colour of focused fields and hovered buttons              |
| `font`        | `JetBrainsMono Nerd Font` | must be installed system-wide                      |
| `formScreen`  | `largest`          | which monitor shows the form: `largest`, `all` or `primary` |
| `card`        | `true`             | frosted card behind the form                              |
| `cardTint`    | `#1c1f29`          | card colour (dark for bright wallpapers, light for dark)  |
| `cardOpacity` | `0.35`             | how strong the tint is                                    |
| `cardBorder`  | `0.10`             | opacity of the card's hairline border                     |
| `cardBlur`    | `0.8`              | frost behind the card (0 = clear glass)                   |
| `textShadow`  | `true`             | soft shadow under the clock and date                      |

To compare versions side by side, `--screenshot` saves an image of each screen, then exits:

```sh
./install.sh --preset dark --preview --screenshot /tmp/sddm-dark ~/Pictures/wallpapers/x.png
# → /tmp/sddm-dark-1920.png, /tmp/sddm-dark-2560.png
```

## Gotchas

- **Qt6 only.** `metadata.desktop` sets `QtVersion=6`. Arch's Qt5 greeter has no Qt5
  libraries installed, so without that line you'd get SDDM's plain fallback screen.
- **Relative image paths** are resolved with `Qt.resolvedUrl` in `Main.qml`. Under Qt6,
  SDDM otherwise looks for them in `/usr/lib/qt6/qml/SddmComponents/` and the
  background comes out white.
- **Form on the wrong monitor?** `formScreen=largest` picks the biggest screen by size. If
  that's wrong on a host, add `formScreen=all` to its preset.
- **Fonts and wallpapers must be readable by the `sddm` user.** That's why the
  wallpaper is copied into the theme instead of linked from `$HOME`.
