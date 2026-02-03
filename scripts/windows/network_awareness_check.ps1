# Network Awareness Check - Windows
# Focus: Local network activity awareness
# Non-destructive and observational only

param(
    [switch]$VerboseMode
)

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " Network Awareness Check - Windows" -ForegroundColor Cyan
Write-Host " Local network observation only" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "This module observes local network activity."
Write-Host "No external monitoring is performed."
Write-Host ""

# 1) Active connections
if ($VerboseMode) {
    Write-Host "Checking active TCP network connections (local view)..." -ForegroundColor DarkGray
}

Write-Host "[+] Active network connections (TCP)" -ForegroundColor Yellow

try {
    Get-NetTCPConnection |
        Select-Object -First 20 State, LocalAddress, LocalPort, RemoteAddress, RemotePort
} catch {
    Write-Host "Get-NetTCPConnection not available. Falling back to netstat." -ForegroundColor DarkYellow
    netstat -ano | Select-Object -First 25
}

Write-Host ""

# 2) Processes using network (best effort)
if ($VerboseMode) {
    Write-Host "Mapping connections to processes (best effort)..." -ForegroundColor DarkGray
}

Write-Host "[+] Processes using network (best effort)" -ForegroundColor Yellow

try {
    $conns = Get-NetTCPConnection |
        Where-Object { $_.OwningProcess -ne 0 } |
        Select-Object -First 30 State, LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess

    foreach ($c in $conns) {
        $p = Get-Process -Id $c.OwningProcess -ErrorAction SilentlyContinue
        $pname = if ($p) { $p.ProcessName } else { "unknown" }

        "{0,-18} {1,6}  {2}:{3} -> {4}:{5}  {6}" -f `
            $pname, $c.OwningProcess, $c.LocalAddress, $c.LocalPort, $c.RemoteAddress, $c.RemotePort, $c.State
    }
} catch {
    Write-Host "Process mapping not available on this system. Showing netstat output." -ForegroundColor DarkYellow
    netstat -bano | Select-Object -First 25
}

Write-Host ""

# 3) Listening ports
if ($VerboseMode) {
    Write-Host "Inspecting local listening ports..." -ForegroundColor DarkGray
}

Write-Host "[+] Listening ports (TCP)" -ForegroundColor Yellow

try {
    Get-NetTCPConnection -State Listen |
        Select-Object -First 20 LocalAddress, LocalPort, OwningProcess
} catch {
    Write-Host "Listening port view not available. Falling back to netstat." -ForegroundColor DarkYellow
    netstat -ano | findstr LISTENING | Select-Object -First 25
}

Write-Host ""
Write-Host "Network awareness check completed." -ForegroundColor Green
exit 0

