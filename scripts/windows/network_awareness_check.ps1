# Network Awareness Check - Windows
# Focus: Local network activity awareness
# Non-destructive and observational only

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " Network Awareness Check - Windows" -ForegroundColor Cyan
Write-Host " Local network observation only" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "This module observes local network activity."
Write-Host "No external monitoring is performed."
Write-Host ""

Write-Host "[+] Active network connections (TCP)" -ForegroundColor Yellow

try {
    Get-NetTCPConnection |
        Select-Object -First 20 State, LocalAddress, LocalPort, RemoteAddress, RemotePort
} catch {
    Write-Host "Get-NetTCPConnection not available. Falling back to netstat." -ForegroundColor DarkYellow
    netstat -ano | Select-Object -First 25
}

Write-Host ""
