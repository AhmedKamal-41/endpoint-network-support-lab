# Runbook: External Monitor Not Detected

## Issue Summary
A user connects an external monitor to their laptop (often via a dock) and it stays black or isn't detected. Usually a cable, input, dock, or display-mode issue.

## Symptoms
- External monitor black / "No signal"
- Only the laptop screen works
- Monitor detected but wrong resolution or flickering
- Works sometimes / drops out intermittently

## First Questions to Ask the User
- How is it connected (HDMI, DisplayPort, USB-C, dock)?
- Did it work before, or is this a new setup?
- Is the monitor powered on and set to the right input source?
- One external monitor or two? Through a docking station?
- Did anything change (new dock, cable, Windows update)?

## Troubleshooting Steps
1. Confirm the **monitor is on** and set to the correct **input source** (HDMI 1/2, DP, USB-C).
2. **Reseat both ends** of the video cable; try a different cable and a different port.
3. Press **Win + P** and choose **Extend** (or Duplicate) — the display mode may be set to "PC screen only."
4. **Win + Ctrl + Shift + B** to restart the graphics driver (screen blinks; safe).
5. In **Settings → Display → Detect**, force a redetect.
6. If using a **dock**, unplug/replug the dock, try the monitor directly into the laptop to isolate the dock.
7. **Update the graphics driver** (and dock firmware if applicable).
8. Reboot with the monitor connected and re-test.

## Tools Used
- Settings → Display, Win + P, Win + Ctrl + Shift + B
- Device Manager (Display adapters)
- Docking station / cables

## Safe Commands (if applicable)
```powershell
# List detected monitors (basic)
Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorID -ErrorAction SilentlyContinue |
  ForEach-Object { ($_.UserFriendlyName | Where-Object {$_}) -as [char[]] -join '' }

# Check display adapter status
Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, Status
```
> Most monitor fixes are physical (cable/input/mode). Commands mainly confirm what's detected.

## Resolution
Example: The dock's video output had come loose and the display mode was set to "PC screen only." Reseating the dock cable and switching to **Extend** with Win + P restored the external monitor.

## When to Escalate
- Suspected faulty dock, cable, or monitor hardware → escalate for replacement.
- Graphics driver issues that won't resolve with a standard update → escalate.
- Multi-monitor setup with persistent driver conflicts → escalate for deeper driver work.

## Prevention Tips
- Use known-good cables and docks; label working setups.
- Keep graphics drivers and dock firmware current.
- Set the standard display mode (Extend) in the user's profile.
- Power the monitor on before/with the laptop.
