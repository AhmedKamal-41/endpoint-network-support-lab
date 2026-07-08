# Runbook: Software Install Request

## Issue Summary
A user requests new software. This isn't a fault — it's a standard request that Level 1 handles with the right approvals, licensing, and a safe install. Documenting this shows you understand process, not just fixes.

## Symptoms / Trigger
- "Can you install [app] for me?"
- A role change needs a new tool
- A vendor requires specific software to work with QueensBridge

## First Questions to Ask the User
- Exactly which software and version?
- What's the business reason / which task needs it?
- Is there an existing license, or does it need to be purchased?
- Is there an approved alternative already available (e.g. in the software portal)?
- Any deadline?

## Troubleshooting / Handling Steps
1. **Verify the request** — confirm the exact software, version, and business justification.
2. **Check policy & approval** — is this app approved for the environment? Does it need manager/IT approval? Record who approved it.
3. **Check licensing** — is a license available, or does it need to be purchased/assigned? Never use unlicensed or pirated software.
4. **Security check** — download only from the official vendor or the internal software portal; confirm it's supported and safe.
5. **Confirm system requirements** — disk space, OS version, admin rights. Free space first if needed ([low-disk-space.md](low-disk-space.md)).
6. **Install** via the approved method (software portal / packaged installer / with proper admin rights).
7. **Verify** it launches and works; connect VPN first if it needs internal resources.
8. **Update records** — add the app to the device's row in [../asset-inventory/it-asset-inventory.csv](../asset-inventory/it-asset-inventory.csv) and close the ticket.

## Tools Used
- Software portal / Company Portal (if present)
- Vendor's official installer
- Asset inventory tracker

## Safe Commands (if applicable)
```powershell
# Confirm what's already installed before adding software
Get-Package | Select-Object Name, Version | Sort-Object Name

# Verify free disk space for the install
Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'" |
  Select-Object @{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,1)}}
```
> Only install software that is approved, licensed, and from a trusted source.

## Resolution
Example: A Finance user needed a PDF editor. Confirmed an approved, licensed option existed in the software portal, verified disk space, installed it, tested it, and added it to the device's inventory record.

## When to Escalate
- Software isn't approved / needs purchasing → escalate to IT lead / procurement for approval and license.
- Install requires admin packaging or deployment tools beyond L1 → escalate to whoever manages software deployment.
- App has security or compatibility concerns → escalate to security before installing.

## Prevention Tips
- Maintain a list of approved/standard software so common requests are quick.
- Track licenses so seats aren't wasted or overused.
- Record installed apps in the inventory for audits and offboarding.
- Steer users to portal apps instead of ad-hoc downloads.
