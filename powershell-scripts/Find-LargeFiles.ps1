<#
.SYNOPSIS
    Find-LargeFiles.ps1 - List the largest files under a folder.

.DESCRIPTION
    Scans a folder (default: the current user's profile) and lists the biggest
    files so you can decide what to move or remove. READ-ONLY: it never deletes
    anything - it only reports.

.WHY
    When a laptop is full, this shows where the space went so you and the user
    can decide together what to clean up. See low-disk-space runbook.

.PARAMETER Path
    Folder to scan. Defaults to the current user's profile folder.

.PARAMETER Top
    How many files to list. Default 15.

.PARAMETER MinSizeMB
    Ignore files smaller than this many MB. Default 100.

.NOTES
    Level 1 IT Support Lab - QueensBridge Medical Office (fictional).
#>

param(
    [string]$Path = "$env:USERPROFILE",
    [int]$Top = 15,
    [int]$MinSizeMB = 100
)

Write-Host "========= FIND LARGE FILES =========" -ForegroundColor Cyan
Write-Host "Scanning: $Path" -ForegroundColor Cyan
Write-Host "(Files larger than $MinSizeMB MB, top $Top) - READ ONLY" -ForegroundColor Cyan
Write-Host ""

try {
    $minBytes = $MinSizeMB * 1MB

    $files = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Length -gt $minBytes } |
        Sort-Object Length -Descending |
        Select-Object -First $Top

    if (-not $files) {
        Write-Host "No files larger than $MinSizeMB MB found." -ForegroundColor Green
        return
    }

    $files | ForEach-Object {
        [PSCustomObject]@{
            SizeMB = [math]::Round($_.Length / 1MB, 1)
            Path   = $_.FullName
        }
    } | Format-Table -AutoSize

    Write-Host ""
    Write-Host "Review these WITH the user before removing anything." -ForegroundColor Yellow
}
catch {
    Write-Host "ERROR: Could not scan for large files." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
