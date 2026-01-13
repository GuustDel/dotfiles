#!/bin/bash
DIR="$HOME/.config/backgrounds"
THUMB_DIR="$HOME/.cache/wallpaper-thumbs"

# Create thumbnail directory
mkdir -p "$THUMB_DIR"

# Optional: clear old thumbnails to remove unused ones
rm -f "$THUMB_DIR"/*

# Generate thumbnails for all wallpapers
for img in "$DIR"/*; do
    [ -f "$img" ] || continue
    filename=$(basename "$img")
    base="${filename%.*}"  # strip extension
    convert "$img" -thumbnail 128x128 "$THUMB_DIR/$base.png"
done

echo "✅ Thumbnails generated in $THUMB_DIR"
