# Runbook: Printer Not Working

## Issue Summary
A user can't print. This runbook covers the endpoint side (queue, spooler, driver, connection). If the whole office lost a network printer, also check [../network-troubleshooting/printer-ip-changed.md](../network-troubleshooting/printer-ip-changed.md).

## Symptoms
- Job "prints" but nothing comes out
- Jobs stuck "in queue" / "error"
- Printer shows offline on the laptop
- "Printer not found" when trying to print

## First Questions to Ask the User
- Which printer (front desk, billing, back office)?
- Is anyone else able to print to it?
- Any error on the printer's own screen (paper, toner, jam)?
- Did it ever work from this laptop, or is this the first time?
- Wired, Wi-Fi, or VPN right now?

## Troubleshooting Steps
1. **Check the printer physically** — powered on, has paper/toner, no jam, no panel error.
2. Confirm the printer is **online** in Settings → Bluetooth & devices → Printers. Clear any "Use Printer Offline" setting.
3. Open the **print queue**; cancel stuck/errored jobs.
4. **Restart the print spooler** with [../powershell-scripts/Restart-PrintSpooler.ps1](../powershell-scripts/Restart-PrintSpooler.ps1) (safe, common fix for stuck queues).
5. Send a **test page** (Printer properties → Print Test Page).
6. If others can print but this user can't, the issue is local — re-add the printer or update the driver.
7. If **no one** can print to it, it's likely the printer/network — check IP and connectivity ([../network-troubleshooting/printer-ip-changed.md](../network-troubleshooting/printer-ip-changed.md)).
8. Reinstall the printer/driver if needed and re-test.

## Tools Used
- Settings → Printers, print queue
- `services.msc` / PowerShell spooler restart
- Printer's own control panel

## Safe Commands (if applicable)
```powershell
# Restart the print spooler (clears stuck queues)
Restart-Service -Name Spooler -Force

# List installed printers and their status
Get-Printer | Select-Object Name, PrinterStatus, PortName

# Test reachability of a network printer's print port
Test-NetConnection 192.168.1.50 -Port 9100
```

## Resolution
Example: Jobs were stuck in the queue and the spooler was hung. Restarting the print spooler and clearing the queue let a test page print immediately.

## When to Escalate
- Printer hardware fault (won't power, hardware error code) → escalate for repair/vendor.
- Printer needs network reconfiguration you can't perform → escalate to MSP (see network runbook).
- Shared print server / driver deployment issue → escalate to server team.

## Prevention Tips
- Keep paper/toner stocked and clear jams promptly.
- Use static IPs for network printers so addresses don't change.
- Standardize on a known-good driver across laptops.
- Restart the printer occasionally to clear its internal queue.
