## Security check scripts – Linux

This section documents the scripts located in:
scripts/linux/

They were created with a defensive security, learning-oriented, and awareness-driven mindset.

# basic_security_check.sh

# Purpose:
Perform basic operating system checks to identify common risk indicators.

# What it checks:

suspicious permissions

unusual running processes

relevant environment variables

sensitive directories

# What it does NOT do:

does not access the internet

does not collect data

does not interact with games

does not modify the system

# When to use:

before playing

after installing mods

after installing launchers or external tools

# minecraft_mod_check.sh

# Purpose:
Help users stay aware of mods present on their system.

# What it does:

checks common mod directories

flags unusual names or patterns

encourages manual review

# Important:
This script does not claim a mod is malicious.
It only promotes conscious inspection.

# Notice:
These scripts are educational.
They do not replace professional security tools.


## Security check scripts – Windows

Location:
scripts/windows/


## basic_security_check.ps1

**Purpose:**  
Run basic Windows security checks.

**What it checks:**
- running processes
- basic permissions
- environment variables
- common risk directories

**What it does NOT do:**
- no data collection
- no server interaction
- no system modification
- no game interaction


## minecraft_mod_check.ps1

**Purpose:**  
Encourage conscious review of installed mods.

**What it does:**
- checks common mod folders
- flags unusual names
- promotes manual inspection

**Notice:**  
It does not claim anything is malicious.  
It is educational only.


## Network Awareness Check (Windows)

Windows version of the network awareness module.

This script allows users to:
- view active network connections
- identify processes using the network
- observe listening ports

All checks are local.
No traffic interception.
No external data collection.
