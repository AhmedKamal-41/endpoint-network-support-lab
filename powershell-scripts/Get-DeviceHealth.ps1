<#
.SYNOPSIS
    Get-DeviceHealth.ps1 - One-page health snapshot of a Windows device.

.DESCRIPTION
    Prints computer name, user, OS version, uptime, CPU/RAM, and C: disk space
    in a clean, readable format. Read-only and safe to run on any device.

.WHY
    Useful as a quick "how is this machine doing?" check at the start of a
    support ticket, before deciding what to troubleshoot next.

.NOTES
    Level 1 IT Support Lab - QueensBridge Medical Office (fictional).
    Run in Windows PowerShell. No admin rights required for the basics.
#>

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "        DEVICE HEALTH SNAPSHOT" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

try {
    $os   = Get-CimInstance Win32_OperatingSystem
    $cs   = Get-CimInstance Win32_ComputerSystem
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

    # Basic identity
    Write-Host ""
    Write-Host "Computer Name : $($env:COMPUTERNAME)"
    Write-Host "User          : $($env:USERNAME)"
    Write-Host "OS            : $($os.Caption) ($($os.Version))"
    Write-Host "Manufacturer  : $($cs.Manufacturer) $($cs.Model)"

    # Uptime
    $lastBoot = $os.LastBootUpTime
    $uptime   = (Get-Date) - $lastBoot
    Write-Host "Last Boot     : $lastBoot"
    Write-Host "Uptime        : $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m"

    # Memory
    $totalRam = [math]::Round($cs.TotalPhysicalMemory / 1GB, 1)
    $freeRam  = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    Write-Host "Total RAM     : $totalRam GB"
    Write-Host "Free RAM      : $freeRam GB"

    # Disk (C:)
    $freeGB  = [math]::Round($disk.FreeSpace / 1GB, 1)
    $sizeGB  = [math]::Round($disk.Size / 1GB, 1)
    $freePct = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1)
    Write-Host "Disk C: Size  : $sizeGB GB"
    Write-Host "Disk C: Free  : $freeGB GB ($freePct%)"

    # Simple health flag on disk
    Write-Host ""
    if ($freePct -lt 10) {
        Write-Host "WARNING: Low disk space (under 10% free)." -ForegroundColor Yellow
    } else {
        Write-Host "Disk space looks OK." -ForegroundColor Green
    }
}
catch {
    Write-Host "ERROR: Could not gather device health info." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host ""
Write-Host "Snapshot complete." -ForegroundColor Cyan
