# Runbook: Slow Laptop

## Issue Summary
A user reports their Windows laptop is slow — slow to boot, slow to open apps, or laggy overall. Level 1 checks resource usage, startup load, disk space, and pending updates before escalating hardware.

## Symptoms
- Long boot time; spinning cursor
- Apps take a long time to open or freeze
- Fans running constantly / laptop hot
- Everything feels sluggish, not just one app

## First Questions to Ask the User
- When did it start — gradually or after a specific change/update?
- Is it slow all the time or only with certain apps?
- Roughly how full is the hard drive, if they know?
- Did anything new get installed recently?
- Has it been restarted lately? (Many laptops run for weeks.)

## Troubleshooting Steps
1. **Restart** the laptop first — clears memory and stuck processes. Check uptime with [../powershell-scripts/Get-SystemUptime.ps1](../powershell-scripts/Get-SystemUptime.ps1).
2. Open **Task Manager** → Processes; sort by CPU, then Memory, then Disk. Note anything pegged at ~100%.
3. Check **disk space** — a nearly full drive slows Windows badly. See [low-disk-space.md](low-disk-space.md).
4. Review **Startup** apps (Task Manager → Startup) and disable heavy, non-essential ones. See [../powershell-scripts/Get-StartupApps.ps1](../powershell-scripts/Get-StartupApps.ps1).
5. Check for **pending Windows/driver updates** — a stuck update can hog resources. See [windows-update-stuck.md](windows-update-stuck.md).
6. Run a quick **malware/EDR scan** if resource use is unexplained.
7. Clear temp files safely with [../powershell-scripts/Clear-TempFiles-Safe.ps1](../powershell-scripts/Clear-TempFiles-Safe.ps1).
8. Re-test and confirm with the user.

## Tools Used
- Task Manager / Resource Monitor
- PowerShell: [Get-DeviceHealth.ps1](../powershell-scripts/Get-DeviceHealth.ps1), [Get-StartupApps.ps1](../powershell-scripts/Get-StartupApps.ps1), [Get-SystemUptime.ps1](../powershell-scripts/Get-SystemUptime.ps1)
- Windows Update, EDR/antivirus

## Safe Commands (if applicable)
```powershell
Get-CimInstance Win32_OperatingSystem | Select-Object LastBootUpTime
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 Name, @{Name='Mem(MB)';Expression={[math]::Round($_.WorkingSet/1MB)}}
Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object @{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,1)}}
```

## Resolution
Example: The laptop hadn't rebooted in 24 days and had a large sync client plus several startup apps loading at boot. A restart, disabling two startup items, and clearing temp files brought performance back to normal.

## When to Escalate
- Consistent 100% disk on an older spinning drive → likely failing/undersized drive → escalate for SSD/hardware review.
- High resource use with no clear cause + EDR flags → escalate to security.
- Slowness persists after all software fixes → escalate for hardware diagnostics (RAM/drive).

## Prevention Tips
- Restart at least once a week.
- Keep ~15% of the disk free.
- Limit startup apps to essentials.
- Install updates promptly instead of deferring for weeks.
