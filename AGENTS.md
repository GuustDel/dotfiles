# Repository Guidelines

## Project Structure & Module Organization

This repository is a GNU Stow-managed dotfiles repo. Each top-level directory is a package that mirrors files into `~/.config` or related paths, for example [`i3/.config/i3/config`](/home/guust/dotfiles/i3/.config/i3/config) and [`rofi/.config/rofi/config.rasi`](/home/guust/dotfiles/rofi/.config/rofi/config.rasi). Key packages include `i3`, `polybar`, `rofi`, `kitty`, `alacritty`, `dunst`, `picom`, `nvim`, `ranger`, `backgrounds`, and `scripts`. Wallpaper assets live under `backgrounds/.config/backgrounds`. Helper shell scripts live in `scripts/scripts`. Theming planning and migration notes are tracked in [`context.md`](/home/guust/dotfiles/context.md).

## Build, Test, and Development Commands

There is no build system. Common local commands:

- `stow i3 polybar rofi kitty dunst backgrounds scripts` installs or refreshes symlinks for active packages.
- `stow -R <package>` restows one package after edits.
- `bash scripts/scripts/generate-wallpaper-thumbs.sh` regenerates wallpaper thumbnails in `~/.cache/wallpaper-thumbs`.
- `i3-msg reload` reloads i3 after config changes.
- `~/.config/polybar/launch_polybar.sh` restarts Polybar on all connected monitors.

## Coding Style & Naming Conventions

Follow the style already used in the repo:

- Shell scripts use `#!/bin/bash`, two-space indentation, and lowercase variable names only when they are truly local; environment-style globals are uppercase.
- Lua uses two-space indentation and small, direct modules.
- Keep config files readable and close to upstream syntax. Do not reformat whole files without need.
- Name new scripts and generated fragments in lowercase, using hyphens or underscores to match surrounding files, for example `launch_polybar.sh` or `battery-notify.sh`.

## Testing Guidelines

There is no automated test suite yet. Validate changes manually:

- restow the affected package
- reload or restart the relevant program
- confirm behavior in the live desktop session

For visual changes, verify both startup behavior and reload behavior. For wallpaper or theme work, also confirm cache files under `~/.cache` update correctly.

## Commit & Pull Request Guidelines

Recent history uses short, informal messages such as `sync`, `stable`, and `added ranger :`. Keep commits short, but prefer clearer imperative summaries with scope, such as `rofi: add theme picker` or `i3: extract theme include`.

Pull requests should list affected packages, mention manual verification steps, and include screenshots for UI changes such as rofi, polybar, wallpapers, or theming updates. Do not commit machine-local cache files or generated runtime state.
