<#
.SYNOPSIS
    Check-DiskSpace.ps1 - Report free and used space on all local drives.

.DESCRIPTION
    Lists each fixed drive with total, used, and free space plus a percent-free
    value, and flags any drive under 15% free. Read-only and safe.

.WHY
    Low disk space causes slowness and failed updates. This is the fastest way
    to confirm a "my laptop is full / slow" ticket. See low-disk-space runbook.

.NOTES
    Level 1 IT Support Lab - QueensBridge Medical Office (fictional).
#>

Write-Host "============ DISK SPACE REPORT ============" -ForegroundColor Cyan
Write-Host "Computer: $env:COMPUTERNAME" -ForegroundColor Cyan
Write-Host ""

try {
    # DriveType 3 = local fixed disk
    $drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

    foreach ($d in $drives) {
        $sizeGB  = [math]::Round($d.Size / 1GB, 1)
        $freeGB  = [math]::Round($d.FreeSpace / 1GB, 1)
        $usedGB  = [math]::Round(($d.Size - $d.FreeSpace) / 1GB, 1)
        $freePct = if ($d.Size -gt 0) { [math]::Round(($d.FreeSpace / $d.Size) * 100, 1) } else { 0 }

        Write-Host "Drive $($d.DeviceID)" -ForegroundColor White
        Write-Host "   Size : $sizeGB GB"
        Write-Host "   Used : $usedGB GB"
        Write-Host "   Free : $freeGB GB ($freePct%)"

        if ($freePct -lt 15) {
            Write-Host "   STATUS: LOW - free up space soon." -ForegroundColor Yellow
        } else {
            Write-Host "   STATUS: OK" -ForegroundColor Green
        }
        Write-Host ""
    }
}
catch {
    Write-Host "ERROR: Could not read disk information." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host "Report complete." -ForegroundColor Cyan
