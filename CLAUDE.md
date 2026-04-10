# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository managed with **GNU Stow**. Each top-level directory is a Stow package. Running `stow <package>` from `~/dotfiles` creates symlinks into `~` (using `.config/` subdirs as the target structure).

```sh
cd ~/dotfiles
stow i3         # symlinks i3/.config/i3/ → ~/.config/i3/
stow nvim       # symlinks nvim/.config/nvim/ → ~/.config/nvim/
stow -D i3      # remove symlinks for i3
```

## Packages

| Package | App | Notes |
|---------|-----|-------|
| `alacritty` | Terminal | |
| `dunst` | Notifications | |
| `i3` | Window manager | |
| `kitty` | Terminal | Primary terminal |
| `nvim` | Neovim | lazy.nvim plugin manager |
| `picom` | Compositor | |
| `polybar` | Status bar | Launched via `launch_polybar.sh` |
| `ranger` | File manager | |
| `rofi` | App launcher | |
| `scripts` | Utility scripts | Battery notify, wallpaper thumbnails |
| `backgrounds` | Wallpapers | |

## Theme

All configs currently use **Gruvbox Dark** colors, hard-coded directly in each config file. The same 12-color palette appears in i3, polybar, rofi, dunst, and kitty. There is an in-progress plan (see `context.md`) to refactor this into a manifest-driven, template-generated theme system — enabling theme switching without manually editing each config file.

## Neovim

Uses lazy.nvim (auto-bootstrapped on first load). Config entry point: `nvim/.config/nvim/init.lua`, with modules in `nvim/.config/nvim/lua/`.
