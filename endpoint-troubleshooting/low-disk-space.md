# Runbook: Low Disk Space

## Issue Summary
A laptop's C: drive is nearly full. This causes slowness, failed updates, and apps that won't save. Level 1 frees space safely without deleting the user's important files.

## Symptoms
- "Low disk space" warning / red drive bar in File Explorer
- Windows Update fails for lack of space
- Apps can't save or crash
- General slowness (see [slow-laptop.md](slow-laptop.md))

## First Questions to Ask the User
- Do you keep large files locally (videos, images, backups, ISO files)?
- Are your files backed up to OneDrive or a department share?
- Is there anything on the desktop/Downloads you no longer need?
- Did this start after a large download or install?

## Troubleshooting Steps
1. Check current free space with [../powershell-scripts/Check-DiskSpace.ps1](../powershell-scripts/Check-DiskSpace.ps1).
2. Empty the **Recycle Bin** (confirm with the user first).
3. Run **Disk Cleanup** / Storage Sense to remove temp files, old update files, and thumbnails.
4. Clear temp files safely with [../powershell-scripts/Clear-TempFiles-Safe.ps1](../powershell-scripts/Clear-TempFiles-Safe.ps1) — this only touches temp locations, not documents.
5. Find the big offenders with [../powershell-scripts/Find-LargeFiles.ps1](../powershell-scripts/Find-LargeFiles.ps1) and review them **with the user**.
6. Move large personal files to OneDrive or the correct department share, then remove local copies (with permission).
7. Uninstall unused large applications if appropriate.
8. Re-check free space and confirm the warning is gone.

## Tools Used
- File Explorer, Disk Cleanup, Storage Sense, Recycle Bin
- PowerShell: [Check-DiskSpace.ps1](../powershell-scripts/Check-DiskSpace.ps1), [Find-LargeFiles.ps1](../powershell-scripts/Find-LargeFiles.ps1), [Clear-TempFiles-Safe.ps1](../powershell-scripts/Clear-TempFiles-Safe.ps1)

## Safe Commands (if applicable)
```powershell
# Report free space (read-only)
Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'" |
  Select-Object @{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,1)}},
                @{n='SizeGB';e={[math]::Round($_.Size/1GB,1)}}

# Find files larger than 500 MB under a user folder (read-only listing)
Get-ChildItem "$env:USERPROFILE" -Recurse -File -ErrorAction SilentlyContinue |
  Where-Object { $_.Length -gt 500MB } |
  Sort-Object Length -Descending | Select-Object FullName,
  @{n='SizeMB';e={[math]::Round($_.Length/1MB)}}
```
> **Safety:** Never bulk-delete user documents. Only remove temp files, cache, and items the user confirms.

## Resolution
Example: QB-LT-004 was at 7% free. Emptying the Recycle Bin, clearing temp files, and moving ~20 GB of old video recordings to the Operations share restored the drive to ~35% free and updates installed successfully.

## When to Escalate
- Drive is genuinely too small for the user's role → escalate for a larger drive / device swap.
- Space fills again quickly with no obvious cause → escalate to investigate logs/backups/profile bloat.
- Suspicious files consuming space → escalate to security.

## Prevention Tips
- Store files in OneDrive / department shares, not just locally.
- Turn on Storage Sense to auto-clean temp files.
- Empty the Recycle Bin and Downloads regularly.
- Keep at least ~15% of the drive free.
