# Context: Omarchy-Inspired Theming for Arch + i3

## Goal

Build an Omarchy-like theme system for this Arch + i3 setup without trying to port Omarchy itself.

The target experience is:

- switch themes from a simple menu
- each theme has a shared palette plus matching wallpapers
- switching a theme updates multiple components together
- the source of truth lives in this dotfiles repo
- generated runtime theme files land in `~/.config`

The agreed direction is **Option B**:

- one theme manifest per theme
- generate app-specific configs from templates
- keep base configs stable
- avoid full per-theme copies of entire app configs

## Core Design Decisions

### What to copy from Omarchy

Copy the architecture, not the distro:

- a theme directory per theme
- a single source of truth for colors and theme metadata
- a script that renders or swaps app-specific config fragments
- an apply step that reloads or restarts affected components

### What not to do

- do not try to install Omarchy pieces directly onto i3
- do not duplicate full configs per theme for i3, polybar, kitty, etc.
- do not make generated files the git-tracked source of truth

## Repository Model

This repo uses a dotfiles + Stow workflow, so the recommended model is:

- this repo is the source of truth
- Stow exposes stable config files into `~/.config`
- generated theme files are runtime artifacts in `~/.config`
- generated files should not be committed

From the system point of view, the theme system lives under `~/.config`.
From the maintenance point of view, the real source lives here in the dotfiles repo.

## Current Repo State

Current top-level packages relevant to theming:

- `i3`
- `polybar`
- `rofi`
- `kitty`
- `dunst`
- `backgrounds`
- `scripts`

Current theme state is mostly hard-coded around Gruvbox:

- [`i3/.config/i3/config`](/home/guust/dotfiles/i3/.config/i3/config) defines Gruvbox color variables and i3 client colors directly
- [`polybar/.config/polybar/config.ini`](/home/guust/dotfiles/polybar/.config/polybar/config.ini) contains a hard-coded `[colors]` block
- [`rofi/.config/rofi/config.rasi`](/home/guust/dotfiles/rofi/.config/rofi/config.rasi) points at `@theme "gruvbox-dark"`
- [`rofi/.config/rofi/gruvbox-dark.rasi`](/home/guust/dotfiles/rofi/.config/rofi/gruvbox-dark.rasi) contains a Gruvbox-specific rofi palette
- [`kitty/.config/kitty/kitty.conf`](/home/guust/dotfiles/kitty/.config/kitty/kitty.conf) includes `~/.config/kitty/gruvbox_dark.conf`
- [`kitty/.config/kitty/gruvbox_dark.conf`](/home/guust/dotfiles/kitty/.config/kitty/gruvbox_dark.conf) contains terminal colors
- [`dunst/.config/dunst/dunstrc`](/home/guust/dotfiles/dunst/.config/dunst/dunstrc) hard-codes notification colors
- [`backgrounds/.config/backgrounds`](/home/guust/dotfiles/backgrounds/.config/backgrounds) already contains wallpapers and can inform the wallpaper strategy

This means the repo already has a good baseline, but it needs to be refactored from "theme baked into app configs" to "base config + generated theme fragment".

There is also an existing wallpaper workflow already wired into i3:

- `Mod+Shift+w` runs `~/.config/rofi-wallpaper.sh`
- i3 restores the last wallpaper on startup with `feh --bg-scale "$(cat ~/.cache/last_wallpaper.txt)"`
- the current wallpaper script reads from `~/.config/backgrounds`
- wallpaper thumbnails are cached in `~/.cache/wallpaper-thumbs`
- the last selected wallpaper is stored in `~/.cache/last_wallpaper.txt`

## Recommended Structure

Add a new Stow package for the theme engine:

```text
theming/
└── .config/theming/
    ├── themes/
    │   ├── gruvbox/
    │   │   ├── colors.toml
    │   │   └── wallpapers/
    │   ├── dracula/
    │   └── catppuccin/
    ├── templates/
    │   ├── i3.conf.j2
    │   ├── polybar.ini.j2
    │   ├── rofi.rasi.j2
    │   ├── kitty.conf.j2
    │   └── dunst.conf.j2
    ├── scripts/
    │   ├── apply-theme
    │   ├── pick-theme
    │   └── pick-wallpaper
    └── state/
        └── current_theme
```

Keep the existing app packages as the place for stable base configs:

- `i3`
- `polybar`
- `rofi`
- `kitty`
- `dunst`

## Runtime-Generated Files

These should be written at apply time and should not be stowed or committed:

```text
~/.config/i3/theme.conf
~/.config/polybar/colors.ini
~/.config/rofi/theme-generated.rasi
~/.config/kitty/theme.conf
~/.config/dunst/theme.conf
~/.config/theming/state/current_theme
```

This is the preferred split:

- repo files: stable inputs
- generated files: current applied state

## Base Config Integration Plan

The base configs should be adjusted so each app reads a generated theme fragment.

### i3

Current config contains hard-coded colors.
Target shape:

```i3
include ~/.config/i3/theme.conf
```

### polybar

Current config contains a hard-coded `[colors]` block.
Target shape:

```ini
include-file = ~/.config/polybar/colors.ini
```

### rofi

Current config points directly at a Gruvbox theme.
Target shape:

```css
@theme "theme-generated.rasi"
```

### kitty

Current config includes a Gruvbox-specific file.
Target shape:

```conf
include ~/.config/kitty/theme.conf
```

### dunst

Two viable options:

- generate only a theme include if the config structure stays simple
- generate the full `dunstrc` if includes become awkward

## Theme Manifest

Each theme should have a single manifest, likely `colors.toml`, as the source of truth.

Example fields:

```toml
name = "Gruvbox"
variant = "dark"
gtk_theme = "Gruvbox-Dark-BL"
icon_theme = "Papirus-Dark"
cursor_theme = "Bibata-Modern-Ice"
preview_image = "preview.png"
default_wallpaper = "wallpapers/default.png"

bg = "#282828"
bg_alt = "#3c3836"
fg = "#ebdbb2"
gray = "#a89984"
red = "#cc241d"
orange = "#d65d0e"
yellow = "#d79921"
green = "#98971a"
blue = "#458588"
purple = "#b16286"
aqua = "#689d6a"
accent = "#d79921"
urgent = "#fb4934"
border_active = "#458588"
border_inactive = "#a89984"
highlight = "#fe8019"
```

This manifest should drive:

- i3 borders and client colors
- polybar colors
- rofi theme colors
- kitty terminal palette
- dunst colors
- GTK, icon, and cursor theme selection
- wallpaper selection

The preview image is specifically for the theme picker UI.
It should be shown as the icon in the rofi theme menu, similar to how wallpaper thumbnails are shown today.

## MVP Scope

Start with these components:

- wallpaper
- i3
- polybar
- rofi
- kitty
- dunst
- GTK theme
- icon theme
- cursor theme

Leave these for phase 2:

- Firefox
- Qt theme tooling
- neovim
- btop
- VS Code or VSCodium

## Wallpaper Strategy

Each theme should own its matching wallpapers:

```text
themes/gruvbox/wallpapers/
themes/dracula/wallpapers/
themes/catppuccin/wallpapers/
```

The current wallpaper picker already works like this:

- wallpaper files live in `~/.config/backgrounds`
- `~/.config/rofi-wallpaper.sh` builds a rofi menu with icons from `~/.cache/wallpaper-thumbs`
- a thumbnail generation script uses ImageMagick `convert` to render `128x128` preview images
- the selected wallpaper is applied with `feh` and persisted to `~/.cache/last_wallpaper.txt`

That flow should be preserved, but adapted to the theme system.

The `backgrounds` package can either:

- remain as a shared wallpaper source, or
- be gradually reorganized into per-theme wallpaper folders inside `theming`

The eventual UX should support:

- apply theme and set a default wallpaper
- `Mod+Shift+w` opening a rofi wallpaper picker
- only showing wallpapers belonging to the currently active theme
- reading the active theme from `~/.config/theming/state/current_theme`
- falling back cleanly if a theme has no wallpapers configured

The preferred end state is:

- `apply-theme` stores the active theme
- `pick-wallpaper` reads the active theme
- `pick-wallpaper` only lists wallpapers from `themes/<active-theme>/wallpapers/`
- wallpaper thumbnails are generated per theme or regenerated on demand

If needed, keep a shared wallpaper pool as a fallback, but the main behavior should be theme-scoped wallpaper selection.

## Theme Switcher UX

The desired interaction is a small menu, likely via rofi.

Example flow:

1. run `pick-theme`
2. select a theme directory
3. `apply-theme <theme>` renders files and applies settings
4. reload or restart themed components

This should mirror the current wallpaper picker behavior:

- `Mod+Shift+t` should open a rofi theme picker
- each theme should appear with a rendered preview image as its rofi icon
- the rofi UI should feel similar to the wallpaper picker
- the selected theme should become the active theme in state

A likely i3 binding:

```i3
bindsym $mod+Shift+t exec --no-startup-id ~/.config/theming/scripts/pick-theme
```

Recommended theme preview model:

- each theme directory contains a checked-in preview image such as `preview.png`, or
- a separate render script generates previews into a cache directory such as `~/.cache/theme-previews`

The first version should prefer checked-in preview images because that is simpler and avoids inventing a theme renderer before the theme engine itself exists.

The eventual menu behavior should be:

1. list directories from `~/.config/theming/themes`
2. attach each theme's preview image as the rofi icon
3. select a theme
4. run `apply-theme <theme>`
5. update `current_theme`
6. from then on, `Mod+Shift+w` shows only wallpapers for that theme

## Apply Script Responsibilities

`apply-theme` should:

1. accept a theme name
2. read `colors.toml`
3. render app-specific templates
4. write generated theme files into `~/.config`
5. set wallpaper
6. set GTK, icon, and cursor theme via `gsettings`
7. reload i3
8. restart polybar
9. restart dunst if needed
10. store the active theme in `~/.config/theming/state/current_theme`
11. optionally apply the theme's default wallpaper immediately

There should also be a wallpaper picker script with responsibilities:

1. read `current_theme`
2. list wallpapers only for the active theme
3. show thumbnail icons in rofi
4. apply the selected wallpaper with `feh`
5. persist the last selected wallpaper path in `~/.cache/last_wallpaper.txt`

## Migration Notes

This should be implemented as a refactor of the current Gruvbox-first setup, not as a full rebuild from scratch.

Practical migration path:

1. create the `theming` package
2. add `colors.toml` and template files
3. add `apply-theme`, `pick-theme`, and a theme-aware `pick-wallpaper`
4. convert the current Gruvbox config into the first manifest
5. move current wallpaper handling from the shared flat directory model toward per-theme wallpaper folders
6. update app base configs to include generated theme fragments
7. add a second and third theme only after Gruvbox works end-to-end

## Non-Goals

- no wholesale Omarchy port
- no distro-specific dependency on Hyprland concepts
- no maintaining full duplicate configs per theme

## Summary

The agreed architecture is:

- Omarchy-inspired, not Omarchy-derived
- manifest-driven
- template-generated
- Stow-friendly
- base configs tracked in git
- generated theme state written into `~/.config`

The next implementation step after this context file is to define the exact `colors.toml` schema and scaffold the `theming` package plus the first `apply-theme` MVP for the existing i3, polybar, rofi, kitty, dunst, and wallpaper setup.
