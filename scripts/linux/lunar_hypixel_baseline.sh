#!/usr/bin/env bash
set -euo pipefail

echo "=============================================="
echo " Lunar / Hypixel Baseline - Linux (Local only)"
echo "=============================================="
echo

echo "[+] Time"
date
echo

echo "[+] Java/Minecraft/Lunar-related processes (top 15)"
ps aux | grep -Ei "java|lunar|minecraft" | grep -v grep | head -n 15 || true
echo

echo "[+] Java process IDs (for connection correlation)"
JAVA_PIDS="$(pgrep -f java || true)"
if [ -n "${JAVA_PIDS}" ]; then
  echo "Java PIDs: ${JAVA_PIDS}"
else
  echo "No Java PIDs found right now."
fi
echo

echo "[+] Connections owned by Java (if available)"
if command -v ss >/dev/null 2>&1; then
  if [ -n "${JAVA_PIDS}" ]; then
    # Show a small sample of sockets with process info
    ss -tupna 2>/dev/null | grep -Ei "users:\(\(\"java\"" | head -n 30 || echo "No Java-owned sockets found in sample."
  else
    echo "Skipping: no Java PIDs."
  fi
else
  echo "ss not available; skipping Java-owned socket view."
fi
echo

echo "[+] Network snapshot (top 30)"
if command -v ss >/dev/null 2>&1; then
  ss -tuna | head -n 30
else
  netstat -tuna 2>/dev/null | head -n 30 || true
fi
echo

echo "[+] Minecraft port hint (:25565) in snapshot"
if command -v ss >/dev/null 2>&1; then
  ss -tuna | grep -E ":25565\b" || echo "No :25565 lines found in sample."
else
  netstat -tuna 2>/dev/null | grep -E ":25565\b" || echo "No :25565 lines found in sample."
fi
echo

echo "[+] Notes"
echo "This does not capture credentials or packets."
echo "It only prints local process + connection summaries."
