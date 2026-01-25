# Minecraft Hypixel Security 

This is an **educational repository** focused on **security for Minecraft players**, especially on the **Hypixel** server.  
Here you will learn how to **look, analyze, and protect yourself**, safely and locally — no cheating, no hacks, just smart observation.

---

## Available Languages
- Português (pt-BR)
- English (en-US)

---

## Platforms
- Linux
- Windows

---

## Included Scripts
Currently, we have **Linux security check scripts**:

1. `basic_security_check.sh`  
   - Observes processes, open ports, and risky files  
   - Read-only, does **not collect or send data**  
   - Just watches and judges 😏

2. `minecraft_mod_check.sh`  
   - Lists installed mods  
   - Calculates SHA256 hashes  
   - Does not execute anything, just inspects  
   - Suspicious mods will be **judged with friendly suspicion** 👀

> This project does **not provide cheats, hacks, or bypasses**.  
> It is **educational, safe, and fun**.

---

## How to run (Linux)
1. Open a terminal in the scripts folder:

```bash
cd scripts/linux
chmod +x basic_security_check.sh minecraft_mod_check.sh
./basic_security_check.sh
./minecraft_mod_check.sh
