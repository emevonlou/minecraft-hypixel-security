#!/bin/bash

# Network Awareness Check
# Focus: Local connections and processes only
# Non-destructive script

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
