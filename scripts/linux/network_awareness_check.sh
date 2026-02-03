#!/bin/bash

# Network Awareness Check
# Focus: Local connections and processes only
# Non-destructive script

VERBOSE=false
if [ "$1" = "--verbose" ]; then
  VERBOSE=true
fi

echo "=============================================="
echo " Network Awareness Check - Linux"
echo " Local network observation only"
echo "=============================================="
echo

echo "This module will analyze local connections."
echo "No external monitoring is performed."
echo

echo "[+] Active network connections (local)"
ss -tuna | head -n 20
echo

echo "[+] Processes using network"
lsof -i -P -n | head -n 15
echo

echo "[+] Listening ports"
ss -lntp | head -n 15
echo

echo "Network awareness check completed."
