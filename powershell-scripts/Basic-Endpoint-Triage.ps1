<#
.SYNOPSIS
    Basic-Endpoint-Triage.ps1 - Run all core Level 1 checks on a device at once.

.DESCRIPTION
    A single "first look" script that reports:
      1. Computer name
      2. Logged-on username
      3. OS version
      4. IP address (active connection)
      5. Disk space (C:)
      6. Uptime
      7. Network connection test (gateway + internet)
      8. Print spooler status
      9. Top 5 processes by memory usage
    Everything here is READ-ONLY and safe to run on any machine.

.WHY
    Gives a fast, complete snapshot at the start of almost any support ticket,
    so you can decide which specific runbook to follow next.

.NOTES
    Level 1 IT Support Lab - QueensBridge Medical Office (fictional).
    Run in Windows PowerShell. No changes are made to the system.
#>

function Write-Section($title) {
    Write-Host ""
    Write-Host "-----------------------------------------------" -ForegroundColor DarkCyan
    Write-Host "  $title" -ForegroundColor Cyan
    Write-Host "-----------------------------------------------" -ForegroundColor DarkCyan
}

Write-Host "===============================================" -ForegroundColor Green
Write-Host "        BASIC ENDPOINT TRIAGE REPORT" -ForegroundColor Green
Write-Host "        QueensBridge Medical Office (Lab)" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# ---- 1-3. Identity + OS -------------------------------------------------
Write-Section "1-3. Computer / User / OS"
try {
    $os = Get-CimInstance Win32_OperatingSystem
    Write-Host "Computer Name : $env:COMPUTERNAME"
    Write-Host "Username      : $env:USERNAME"
    Write-Host "OS Version    : $($os.Caption) ($($os.Version))"
}
catch {
    Write-Host "Could not read OS info: $($_.Exception.Message)" -ForegroundColor Red
}

# ---- 4. IP address ------------------------------------------------------
Write-Section "4. IP Address"
try {
    $config = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | Select-Object -First 1
    if ($config) {
        Write-Host "Interface : $($config.InterfaceAlias)"
        Write-Host "IP Address: $($config.IPv4Address.IPAddress)"
        Write-Host "Gateway   : $($config.IPv4DefaultGateway.NextHop)"
    } else {
        Write-Host "No active network connection with a gateway found." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Could not read IP info: $($_.Exception.Message)" -ForegroundColor Red
}

# ---- 5. Disk space (C:) -------------------------------------------------
Write-Section "5. Disk Space (C:)"
try {
    $disk    = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freeGB  = [math]::Round($disk.FreeSpace / 1GB, 1)
    $sizeGB  = [math]::Round($disk.Size / 1GB, 1)
    $freePct = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1)
    Write-Host "Size: $sizeGB GB   Free: $freeGB GB ($freePct%)"
    if ($freePct -lt 15) {
        Write-Host "WARNING: Low disk space." -ForegroundColor Yellow
    } else {
        Write-Host "Disk space OK." -ForegroundColor Green
    }
}
catch {
    Write-Host "Could not read disk info: $($_.Exception.Message)" -ForegroundColor Red
}

# ---- 6. Uptime ----------------------------------------------------------
Write-Section "6. Uptime"
try {
    $lastBoot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $uptime   = (Get-Date) - $lastBoot
    Write-Host "Last Boot: $lastBoot"
    Write-Host "Uptime   : $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m"
    if ($uptime.Days -ge 7) {
        Write-Host "Consider a restart (up 7+ days)." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Could not read uptime: $($_.Exception.Message)" -ForegroundColor Red
}

# ---- 7. Network connection test ----------------------------------------
Write-Section "7. Network Connection Test"
try {
    if (Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet) {
        Write-Host "Internet (8.8.8.8): reachable." -ForegroundColor Green
    } else {
        Write-Host "Internet (8.8.8.8): NOT reachable." -ForegroundColor Yellow
    }

    try {
        $null = Resolve-DnsName "google.com" -ErrorAction Stop
        Write-Host "DNS resolution   : working." -ForegroundColor Green
    } catch {
        Write-Host "DNS resolution   : FAILED." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Could not run network test: $($_.Exception.Message)" -ForegroundColor Red
}

# ---- 8. Print spooler status -------------------------------------------
Write-Section "8. Print Spooler Status"
try {
    $spooler = Get-Service -Name Spooler -ErrorAction Stop
    $color = if ($spooler.Status -eq 'Running') { 'Green' } else { 'Yellow' }
    Write-Host "Print Spooler: $($spooler.Status)" -ForegroundColor $color
}
catch {
    Write-Host "Could not read spooler status: $($_.Exception.Message)" -ForegroundColor Red
}

# ---- 9. Top 5 processes by memory --------------------------------------
Write-Section "9. Top 5 Processes by Memory"
try {
    Get-Process |
        Sort-Object WorkingSet -Descending |
        Select-Object -First 5 Name, Id,
            @{Name='Memory(MB)';Expression={[math]::Round($_.WorkingSet / 1MB, 1)}} |
        Format-Table -AutoSize
}
catch {
    Write-Host "Could not list processes: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host "   Triage complete. Use runbooks for any flags." -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
