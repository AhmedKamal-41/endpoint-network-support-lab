<#
.SYNOPSIS
    Get-StartupApps.ps1 - List programs that run at Windows startup.

.DESCRIPTION
    Shows the apps configured to launch at login/boot, with their name and
    command/location. Read-only - it only reports, it does not disable anything.

.WHY
    Too many startup apps slow down boot and overall performance. This helps
    identify what to disable (via Task Manager > Startup). See slow-laptop runbook.

.NOTES
    Level 1 IT Support Lab - QueensBridge Medical Office (fictional).
#>

Write-Host "========= STARTUP APPLICATIONS =========" -ForegroundColor Cyan
Write-Host "Computer: $env:COMPUTERNAME" -ForegroundColor Cyan
Write-Host "(Read-only list. Disable via Task Manager > Startup.)" -ForegroundColor Cyan
Write-Host ""

try {
    $startup = Get-CimInstance Win32_StartupCommand |
        Select-Object Name, Location, Command, User

    if (-not $startup) {
        Write-Host "No startup entries found (or none visible to this user)." -ForegroundColor Green
        return
    }

    $startup | Format-Table -AutoSize

    Write-Host ""
    Write-Host "Count: $($startup.Count) startup item(s)." -ForegroundColor White
    Write-Host "Tip: disable non-essential items to speed up boot." -ForegroundColor Yellow
}
catch {
    Write-Host "ERROR: Could not list startup applications." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
