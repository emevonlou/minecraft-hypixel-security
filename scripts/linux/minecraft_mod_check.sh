#!/bin/bash

# minecraft_mod_check.sh
# Purpose: Basic security awareness checks for Minecraft mods
# Focus: Local filesystem inspection only
# Scope: No game interaction, no network activity

echo "=============================================="
echo " Minecraft Mod Security Check"
echo " Focus: Awareness, not enforcement"
echo "=============================================="
echo

# 1. Locate common Minecraft directories
echo "[+] Searching for Minecraft directories"

MC_DIRS=(
  "$HOME/.minecraft"
  "$HOME/.local/share/multimc"
  "$HOME/.local/share/PrismLauncher"
)

FOUND_DIRS=()

for dir in "${MC_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "Found: $dir"
    FOUND_DIRS+=("$dir")
  fi
done

if [ "${#FOUND_DIRS[@]}" -eq 0 ]; then
  echo "No known Minecraft directories found."
  exit 0
fi

echo

# 2. Search for mods folders
echo "[+] Searching for mods folders"

MOD_DIRS=()

for base in "${FOUND_DIRS[@]}"; do
  if [ -d "$base/mods" ]; then
    echo "Mods folder found: $base/mods"
    MOD_DIRS+=("$base/mods")
  fi
done

if [ "${#MOD_DIRS[@]}" -eq 0 ]; then
  echo "No mods folders found."
  exit 0
fi

echo

# 3. List mods and basic metadata
echo "[+] Listing mods (filename, size, last modified)"

for mods in "${MOD_DIRS[@]}"; do
  echo "--- $mods ---"
  ls -lh --time-style=long-iso "$mods" | grep -E '\.jar$'
  echo
done

# 4. Look for unusual mod names
echo "[+] Checking for unusual mod names"

SUSPICIOUS_KEYWORDS=("inject" "hack" "cheat" "keylog" "rat" "stealer")

for mods in "${MOD_DIRS[@]}"; do
  for keyword in "${SUSPICIOUS_KEYWORDS[@]}"; do
    if ls "$mods" | grep -i "$keyword" > /dev/null 2>&1; then
      echo "Attention: mod name matching '$keyword' found in $mods"
    fi
  done
done

echo

# 5. Check for executable permission on mod files
echo "[+] Checking for executable permissions on mod files"

for mods in "${MOD_DIRS[@]}"; do
  find "$mods" -type f -name "*.jar" -executable 2>/dev/null | while read -r file; do
    echo "Attention: executable permission set on $file"
  done
done

echo

# 6. Final message
echo "=============================================="
echo " Check completed."
echo " Review mods manually if anything looks odd."
echo " No mods were blocked or removed."
echo "=============================================="

