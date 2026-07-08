<#
.SYNOPSIS
    Clear-TempFiles-Safe.ps1 - Safely clean up temporary files.

.DESCRIPTION
    Deletes files ONLY from known temp locations (the user TEMP folder and the
    Windows TEMP folder). It never touches Documents, Desktop, Downloads, or any
    user data. Files currently in use are skipped automatically.

.WHY
    Temp files build up and waste disk space. Clearing them is a safe first step
    when freeing space or fixing a stuck update. See low-disk-space runbook.

.PARAMETER WhatIfMode
    If set to $true, shows what WOULD be deleted without deleting anything.

.NOTES
    Level 1 IT Support Lab - QueensBridge Medical Office (fictional).
    SAFETY: Only cleans temp folders. Confirm with the user before running.
#>

param(
    [bool]$WhatIfMode = $false
)

Write-Host "======== CLEAR TEMP FILES (SAFE) ========" -ForegroundColor Cyan
if ($WhatIfMode) {
    Write-Host "PREVIEW MODE: nothing will actually be deleted." -ForegroundColor Yellow
}
Write-Host ""

# Only these known-safe temp locations are touched.
$tempPaths = @(
    $env:TEMP,
    "$env:SystemRoot\Temp"
)

$totalFreedMB = 0

foreach ($path in $tempPaths) {
    if (-not (Test-Path $path)) { continue }

    Write-Host "Cleaning: $path" -ForegroundColor White
    try {
        $items = Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue

        foreach ($item in $items) {
            try {
                if ($item.PSIsContainer) { continue }  # handle files; empty folders cleaned below
                $sizeMB = [math]::Round($item.Length / 1MB, 2)

                if ($WhatIfMode) {
                    Write-Host "   WOULD REMOVE: $($item.FullName) ($sizeMB MB)"
                } else {
                    Remove-Item -Path $item.FullName -Force -ErrorAction SilentlyContinue
                    if (-not (Test-Path $item.FullName)) { $totalFreedMB += $sizeMB }
                }
            }
            catch {
                # File in use or protected - skip it safely.
            }
        }
    }
    catch {
        Write-Host "   Could not fully clean this folder (some files in use)." -ForegroundColor Yellow
    }
    Write-Host ""
}

if ($WhatIfMode) {
    Write-Host "Preview complete. Re-run without -WhatIfMode to delete." -ForegroundColor Cyan
} else {
    Write-Host "Done. Approx freed: $([math]::Round($totalFreedMB,1)) MB" -ForegroundColor Green
    Write-Host "Files that were in use were skipped safely." -ForegroundColor Green
}
