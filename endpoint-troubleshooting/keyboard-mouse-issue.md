# Runbook: Keyboard / Mouse Not Working

## Issue Summary
A keyboard or mouse (built-in or external, wired or wireless) isn't responding or behaves erratically. Level 1 checks power, connection, and drivers.

## Symptoms
- No response from keyboard or mouse
- Wireless device lags, skips, or drops
- Some keys don't work / wrong characters
- Touchpad not working on the laptop

## First Questions to Ask the User
- Built-in or external? Wired or wireless (Bluetooth/USB dongle)?
- Did it work before, or is it a new device?
- For wireless: when were the batteries last changed?
- Does it fail everywhere or only in one app?
- Any liquid spill or physical damage?

## Troubleshooting Steps
1. **Wired:** unplug and try a **different USB port**; try the device on another laptop to test the device itself.
2. **Wireless (dongle):** reseat the USB receiver; move it closer / to a front port.
3. **Wireless (Bluetooth):** confirm the device is powered on, **replace/charge batteries**, and re-pair in Settings → Bluetooth.
4. **Touchpad:** check it isn't disabled (Fn key toggle or Settings → Touchpad).
5. Restart the laptop — resolves many driver/HID glitches.
6. In **Device Manager**, look for the device under Keyboards/Mice; if it has a warning, uninstall it and let Windows reinstall on reboot.
7. Test in a text field / a different app to confirm the fix.

## Tools Used
- Device Manager (Keyboards, Mice and other pointing devices)
- Settings → Bluetooth & devices, Touchpad
- Spare known-good keyboard/mouse for swap testing

## Safe Commands (if applicable)
```powershell
# List input devices and their status
Get-PnpDevice -Class Keyboard | Select-Object FriendlyName, Status
Get-PnpDevice -Class Mouse    | Select-Object FriendlyName, Status
```
> Most fixes here are physical (port, batteries, pairing). Use the commands to confirm Windows sees the device.

## Resolution
Example: A wireless mouse was lagging because the USB receiver was plugged into a crowded back port and the batteries were low. New batteries plus moving the receiver to a front port fixed it.

## When to Escalate
- Suspected hardware failure on a built-in keyboard/touchpad → escalate for repair (see asset tracker).
- Spilled liquid / physical damage → escalate; stop using if safety is a concern.
- Persistent driver conflicts after reinstall → escalate.

## Prevention Tips
- Keep spare batteries for wireless peripherals.
- Use quality cables and avoid overloaded USB hubs.
- Keep a spare known-good keyboard/mouse at the desk for quick swaps.
- Report spills immediately — don't keep using a damaged device.
