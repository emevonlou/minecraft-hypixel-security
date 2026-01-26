#!/bin/bash

# basic_security_check.sh
# Purpose: Perform basic local security checks for Linux systems
# Context: Minecraft players (Hypixel-focused), Blue Team mindset
# Scope: Local system only — no network scanning, no exploitation

echo "=============================================="
echo " Basic Security Check - Linux"
echo " Focus: Local system awareness"
echo "=============================================="
echo

# 1. Basic system information
echo "[+] System information"
echo "Hostname: $(hostname)"
echo "User: $(whoami)"
echo "Kernel: $(uname -r)"
echo "Uptime:"
uptime
echo

# 2. Privilege check
echo "[+] Privilege check"
if [ "$EUID" -eq 0 ]; then
  echo "WARNING: Script is running as root."
else
  echo "OK: Script is running as a regular user."
fi
echo

# 3. Suspicious processes (basic awareness)
echo "[+] Checking for suspicious processes"
SUSPICIOUS_PROCESSES=("keylogger" "packet_sniffer" "injector" "miner")

for proc in "${SUSPICIOUS_PROCESSES[@]}"; do
  if pgrep -i "$proc" > /dev/null; then
    echo "WARNING: Process matching '$proc' found running."
  else
    echo "OK: No process matching '$proc' found."
  fi
done
echo

# 4. Network awareness (local only)
echo "[+] Network connections overview"
echo "Active connections:"
ss -tuna | head -n 20
echo

# 5. File permission sanity check (home directory)
echo "[+] Checking for world-writable files in home directory"
find "$HOME" -type f -perm -0002 2>/dev/null | head -n 10
echo "Note: Only first 10 results shown (if any)."
echo

# 6. Environment variables related to Java/Minecraft
echo "[+] Environment variables (Minecraft relevant)"
env | grep -Ei "java|minecraft" || echo "No relevant environment variables found."
echo

# 6.1 Java processes awareness (Minecraft related)
echo "[+] Java processes overview (Minecraft context)"
ps aux | grep -i java | grep -v grep | head -n 10 || echo "No Java processes found."
echo

# 6.2 Hidden executables in home directory
echo "[+] Checking for hidden executable files in home directory"
find "$HOME" -type f -name ".*" -executable 2>/dev/null | head -n 10
echo "Note: Hidden executables are not always malicious, but deserve attention."
echo

# 6.3 Autostart entries (user level)
echo "[+] User autostart entries"
AUTOSTART_DIR="$HOME/.config/autostart"

if [ -d "$AUTOSTART_DIR" ]; then
  ls "$AUTOSTART_DIR"
else
  echo "No user autostart directory found."
fi
echo


# 7. Final message
echo "=============================================="
echo " Check completed."
echo " Review the output carefully."
echo " No automatic actions were taken."
echo "=============================================="

