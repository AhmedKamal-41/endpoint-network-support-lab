<#
.SYNOPSIS
    Get-SystemUptime.ps1 - Show when the device last booted and how long it has been on.

.DESCRIPTION
    Displays the last boot time and total uptime in days/hours/minutes. Read-only.
    Suggests a restart if the device has been running a long time.

.WHY
    Many "it's slow / acting weird" tickets are fixed by a restart. Machines that
    have been up for weeks often just need a reboot. See slow-laptop runbook.

.NOTES
    Level 1 IT Support Lab - QueensBridge Medical Office (fictional).
#>

Write-Host "============ SYSTEM UPTIME ============" -ForegroundColor Cyan
Write-Host "Computer: $env:COMPUTERNAME" -ForegroundColor Cyan
Write-Host ""

try {
    $os       = Get-CimInstance Win32_OperatingSystem
    $lastBoot = $os.LastBootUpTime
    $uptime   = (Get-Date) - $lastBoot

    Write-Host "Last Boot Time : $lastBoot"
    Write-Host "Uptime         : $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes"
    Write-Host ""

    if ($uptime.Days -ge 7) {
        Write-Host "This device has been on for a week or more." -ForegroundColor Yellow
        Write-Host "Recommend a restart to clear memory and finish updates." -ForegroundColor Yellow
    } else {
        Write-Host "Uptime is reasonable - a restart is optional." -ForegroundColor Green
    }
}
catch {
    Write-Host "ERROR: Could not read system uptime." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
