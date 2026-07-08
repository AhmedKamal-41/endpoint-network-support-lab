# Runbook: Application Not Launching

## Issue Summary
A program won't open — nothing happens on click, it crashes on start, or it shows an error. Level 1 works through restart, updates, repair, and reinstall.

## Symptoms
- Double-click does nothing
- App opens then immediately closes
- Error dialog on launch
- App hangs on the splash screen

## First Questions to Ask the User
- Which application, and what happens exactly (nothing / error / crash)?
- When did it last work? Did anything change (update, install)?
- Is there an error message you can read to me or screenshot?
- Does it affect just this app or several?
- Does it need the network/VPN to start (e.g. EHR client)?

## Troubleshooting Steps
1. **Restart the laptop** — clears stuck processes and locks.
2. Check **Task Manager** — is the app already running (a hung background process)? End it and relaunch.
3. Confirm any **network/VPN dependency** is connected (EHR/Billing/HR apps often need it).
4. Check **Windows Update** and the **app's own updates** — an outdated app can break after an OS update.
5. **Run as administrator** once to rule out a permissions issue (only if appropriate).
6. Use the app's **Repair** option (Settings → Apps → the app → Modify/Repair), or repair Microsoft 365 for Office apps.
7. Review **Event Viewer** (Windows Logs → Application) for the error at launch time.
8. If still broken, **uninstall and reinstall** the app (with approval), then re-test.

## Tools Used
- Task Manager, Event Viewer
- Settings → Apps (Repair / Uninstall)
- Vendor installer / software portal

## Safe Commands (if applicable)
```powershell
# See if the app's process is already running
Get-Process | Where-Object { $_.Name -like "*appname*" }

# End a hung process by name (only the target app)
Stop-Process -Name "appname" -Force

# Check recent application errors in the event log
Get-WinEvent -LogName Application -MaxEvents 20 |
  Where-Object LevelDisplayName -eq 'Error' |
  Select-Object TimeCreated, ProviderName, Id
```

## Resolution
Example: The EHR client hung on launch because a previous session was still running in the background. Ending the stuck process and relaunching opened it normally.

## When to Escalate
- App is licensed/managed centrally and needs a server-side fix → escalate to app owner/vendor.
- Reinstall requires admin packaging not available at L1 → escalate.
- Error points to a corrupted OS component (.NET, redistributables) → escalate for repair.

## Prevention Tips
- Keep both Windows and the app updated.
- Fully close apps before shutting down.
- Connect VPN before opening apps that need internal resources.
- Report recurring crashes early so patterns get fixed.
