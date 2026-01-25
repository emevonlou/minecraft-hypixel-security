# basic_security_check.ps1
# Basic local security checks for Windows.
# Read-only. No admin. No drama.

Write-Host "Starting basic security check..."
Write-Host "No administrator privileges required."

Write-Host "`nChecking Minecraft-related processes:"
Get-Process | Where-Object {
    $_.ProcessName -match "java|minecraft|lunar|badlion"
} | Select-Object ProcessName, Id

Write-Host "`nChecking common Minecraft port (25565):"
Get-NetTCPConnection -LocalPort 25565 -ErrorAction SilentlyContinue |
Select-Object LocalAddress, LocalPort, State

Write-Host "`nChecking user startup programs:"
Get-CimInstance Win32_StartupCommand |
Select-Object Name, Command, Location

Write-Host "`nReminder:"
Write-Host "If a mod asks for administrator permissions, the answer is probably no."

Write-Host "`nSecurity check finished."
Write-Host "Nothing was changed."
