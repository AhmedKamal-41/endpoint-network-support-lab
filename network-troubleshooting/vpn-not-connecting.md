# Runbook: VPN Not Connecting

## Issue Summary
A remote employee can't connect to the office VPN, so they can't reach internal shared folders or apps from home. Level 1 verifies the basics before escalating to whoever manages the VPN server.

## Symptoms
- VPN client hangs on "connecting" then fails
- Authentication error after entering credentials
- Connects but internal shares still won't open
- Works on office Wi-Fi but not from home

## Possible Causes
- No / poor home internet before the VPN even starts
- Wrong username, expired password, or MFA issue
- VPN client out of date or misconfigured
- VPN server down or at capacity
- Home firewall/router blocking VPN ports
- DNS not working once connected (see [dns-not-resolving.md](dns-not-resolving.md))

## Commands to Run
```powershell
ping 8.8.8.8                                    # confirm home internet works first
Test-NetConnection vpn.example.com -Port 443    # can we reach the VPN gateway?
ipconfig /all                                   # after connecting: VPN adapter + DNS
Get-VpnConnection                               # list configured VPN profiles (PowerShell)
nslookup qbfiles01                              # after connect: internal name resolves?
```

## Expected Output
Before VPN: internet works. VPN gateway is reachable:
```
Test-NetConnection vpn.example.com -Port 443
TcpTestSucceeded : True
```
After connecting, `ipconfig /all` shows a VPN adapter with an internal IP, and internal names resolve.

## Troubleshooting Steps
1. Confirm home internet works: `ping 8.8.8.8`. No internet = fix that first; the VPN can't work without it.
2. Test reachability to the VPN gateway: `Test-NetConnection vpn.example.com -Port 443`.
3. Re-enter credentials carefully; confirm the password isn't expired and MFA is approved.
4. Restart the VPN client and try again; reboot the laptop if needed.
5. Confirm the VPN client is the current version / correct profile (`Get-VpnConnection`).
6. If it connects but shares don't open, check DNS (`nslookup qbfiles01`) — see [dns-not-resolving.md](dns-not-resolving.md) and [shared-folder-unreachable.md](shared-folder-unreachable.md).
7. Test from a different network (phone hotspot) to rule out the home router/firewall.

## Root Cause Example
The user's domain password had expired. The VPN accepted the connection attempt but failed authentication every time. Resetting the password fixed it immediately.

## Resolution
Reset the expired password (with the account owner), reconnected the VPN, confirmed an internal IP via `ipconfig /all`, and verified a shared folder opened. Advised the user of the new password-expiry date.

## When to Escalate
- VPN gateway unreachable for everyone (`Test-NetConnection` fails widely) → VPN server likely down → escalate to MSP.
- MFA/identity system problem → escalate to whoever manages accounts/MFA.
- VPN connects but internal routing is broken server-side → escalate.

## User-Facing Response
> "Your home internet was fine — the VPN was rejecting the login because your work password had expired. I helped reset it, and you're now connected and able to reach your files. Passwords expire every so often, so I'll note the next date for you."
