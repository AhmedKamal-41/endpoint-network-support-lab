# Screenshots

Real output captured from the PowerShell scripts running on a live Windows 11 machine. Everything shown is from a fictional lab — **no real company data, real names, or credentials.**

| Image | Script | What it shows |
|---|---|---|
| [basic-endpoint-triage.png](basic-endpoint-triage.png) | `Basic-Endpoint-Triage.ps1` | Full first-look snapshot: identity, IP, disk, uptime, connectivity, spooler, top processes |
| [device-health-snapshot.png](device-health-snapshot.png) | `Get-DeviceHealth.ps1` | One-page device health (OS, RAM, disk, uptime) |
| [network-status-check.png](network-status-check.png) | `Check-NetworkStatus.ps1` | IP, gateway, DNS, and gateway/internet/DNS reachability |
| [disk-space-report.png](disk-space-report.png) | `Check-DiskSpace.ps1` | Free/used space on every fixed drive with low-space flags |
| [system-uptime.png](system-uptime.png) | `Get-SystemUptime.ps1` | Last boot time and total uptime, with restart guidance |

## How these were captured

Each script was run for real, its console output (including colors) recorded, and rendered into a terminal-style image so the results read cleanly in the README. The data is genuine output from the machine the scripts ran on.
