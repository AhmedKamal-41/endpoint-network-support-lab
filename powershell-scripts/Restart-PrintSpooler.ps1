<#
.SYNOPSIS
    Restart-PrintSpooler.ps1 - Safely restart the Windows Print Spooler service.

.DESCRIPTION
    Shows the current spooler status, restarts the service, and confirms it is
    running again. This is a common, safe fix for stuck print queues.

.WHY
    "Jobs stuck in the queue / printer offline" is one of the most common help
    desk tickets. Restarting the spooler clears the queue jam. See the
    printer-not-working runbook.

.NOTES
    Level 1 IT Support Lab - QueensBridge Medical Office (fictional).
    May require running PowerShell as Administrator to restart the service.
#>

Write-Host "======== RESTART PRINT SPOOLER ========" -ForegroundColor Cyan

try {
    $svc = Get-Service -Name Spooler -ErrorAction Stop
    Write-Host "Current status: $($svc.Status)"

    Write-Host "Restarting the Print Spooler service..." -ForegroundColor Yellow
    Restart-Service -Name Spooler -Force -ErrorAction Stop

    Start-Sleep -Seconds 2
    $svc = Get-Service -Name Spooler
    if ($svc.Status -eq 'Running') {
        Write-Host "Print Spooler is now: $($svc.Status)" -ForegroundColor Green
        Write-Host "Try printing a test page." -ForegroundColor Green
    } else {
        Write-Host "Print Spooler status: $($svc.Status) - may need another attempt." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "ERROR: Could not restart the Print Spooler." -ForegroundColor Red
    Write-Host "Tip: run PowerShell as Administrator and try again." -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Red
}
