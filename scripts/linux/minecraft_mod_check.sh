#!/bin/bash

# Minecraft Mod Security Check (Linux)
# Mood: Friendly, but suspicious
# Purpose: Inspect mods. Touch nothing. Judge silently.


MODS_DIR="$HOME/.minecraft/mods"

echo "======================================="
echo " Minecraft Mod Security Check "
echo "======================================="
echo "(Relax. This script only looks.)"

# Check if mods directory exists
if [ ! -d "$MODS_DIR" ]; then
  echo -e "\n❌ Mods directory not found:"
  echo "$MODS_DIR"
  echo "Are you sure Minecraft is installed?"
  exit 1
fi

echo -e "\n Mods directory found:"
echo "$MODS_DIR"

echo -e "\n Listing installed mods:"
ls -lh "$MODS_DIR"

echo -e "\n Calculating SHA256 hashes (because trust is earned):"
for mod in "$MODS_DIR"/*.jar; do
  if [ -f "$mod" ]; then
    sha256sum "$mod"
  fi
done

echo -e "\n Friendly reminder:"
echo "- Unknown mods deserve extra attention"
echo "- Compare hashes with official sources"
echo "- Free mods from Discord DMs are suspicious by nature"

echo -e "\n Scan completed."
echo "No mods were harmed. No data was sent."
