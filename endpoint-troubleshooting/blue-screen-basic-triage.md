# Runbook: Blue Screen (BSOD) Basic Triage

## Issue Summary
A laptop crashes to a blue screen ("Your PC ran into a problem") and restarts. Level 1 gathers the stop code, checks recent changes, and applies safe fixes before escalating hardware.

## Symptoms
- Blue screen with a stop code (e.g. `MEMORY_MANAGEMENT`, `DPC_WATCHDOG_VIOLATION`)
- Random restarts, sometimes with a QR code
- Crashes tied to a specific action (docking, sleep, an app)
- Boot loop in worse cases

## First Questions to Ask the User
- What does the blue screen say (stop code / QR)? A photo helps.
- How often does it happen, and does anything trigger it?
- Did it start after a new update, driver, or hardware/dock?
- Is any work unsaved / is data backed up?
- Does it happen on battery, on the dock, or both?

## Troubleshooting Steps
1. **Record the stop code** from the screen — it's the biggest clue. Ask for a photo.
2. If it's a one-off, **note it and monitor**. Repeated crashes need action.
3. Check **Reliability Monitor** / Event Viewer for the crash time and faulting component.
4. Undo **recent changes** — a driver, update, or new peripheral. Unplug external devices/dock and see if it stabilizes.
5. **Update drivers** (especially graphics, storage, chipset) and Windows.
6. Run **memory** (Windows Memory Diagnostic) and **disk** checks if crashes are frequent.
7. Confirm the device isn't **overheating** (blocked vents, constant fan).
8. Document findings and, if hardware is suspected, escalate with the stop code and logs.

## Tools Used
- Reliability Monitor (`perfmon /rel`), Event Viewer
- Windows Memory Diagnostic (`mdsched.exe`)
- Device Manager / Windows Update

## Safe Commands (if applicable)
```powershell
# Recent critical/error system events around a crash
Get-WinEvent -LogName System -MaxEvents 30 |
  Where-Object { $_.LevelDisplayName -in 'Error','Critical' } |
  Select-Object TimeCreated, Id, ProviderName

# Read-only disk health check
Get-CimInstance -Namespace root\wmi -ClassName MSStorageDriver_FailurePredictStatus -ErrorAction SilentlyContinue
```
> Only run `chkdsk`/repair tools with approval and a backup; heavy repairs are typically escalated.

## Resolution
Example: Crashes with `DPC_WATCHDOG_VIOLATION` started after a dock was added. Updating the storage/dock drivers stopped the blue screens. Confirmed stable over several days.

## When to Escalate
- Frequent BSODs, boot loops, or failed memory/disk tests → escalate for hardware diagnostics/repair.
- Crash points to failing RAM or storage → escalate; back up data first.
- Same stop code recurring after driver updates → escalate with logs and the code.

## Prevention Tips
- Keep drivers and Windows updated.
- Back up important files to OneDrive / shares so a crash isn't data loss.
- Don't ignore repeated crashes — report early with the stop code.
- Keep vents clear to avoid overheating.
