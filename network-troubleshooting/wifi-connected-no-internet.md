# Runbook: Wi-Fi Connected but No Internet

## Issue Summary
The laptop shows it's connected to Wi-Fi (`Staff-WiFi`), but web pages and apps won't load. The wireless link is up; something between the laptop and the internet is broken.

## Symptoms
- Wi-Fi icon shows connected, but "No internet"
- Browser can't load pages
- Apps that need the internet time out
- Other devices on the same Wi-Fi may or may not work

## Possible Causes
- No valid IP / DHCP problem (see [dhcp-issue.md](dhcp-issue.md))
- DNS not resolving (see [dns-not-resolving.md](dns-not-resolving.md))
- Router lost its internet (WAN/ISP) connection
- Connected to the wrong / isolated Wi-Fi (e.g. `Guest-WiFi` restrictions)
- Captive portal / expired session

## Commands to Run
```powershell
ipconfig /all                       # do we have a real IP + gateway?
ping 192.168.1.1                    # can we reach the router?
ping 8.8.8.8                        # can we reach the internet by IP?
nslookup google.com                 # does DNS resolve?
Test-NetConnection -ComputerName 8.8.8.8   # PowerShell reachability test
```

## Expected Output
Working path looks like: valid IP → gateway ping succeeds → `8.8.8.8` ping succeeds → `nslookup` resolves. The first step that fails tells you where the break is.
```
Ping 192.168.1.1  -> Reply (router OK)
Ping 8.8.8.8      -> Request timed out (internet down beyond router)
```

## Troubleshooting Steps
1. `ipconfig /all` — confirm a real IP (not `169.254.x.x`) and a gateway. If bad, go to [dhcp-issue.md](dhcp-issue.md).
2. `ping 192.168.1.1` — if the router doesn't reply, it's a local network problem (see [cannot-ping-gateway.md](cannot-ping-gateway.md)).
3. `ping 8.8.8.8` — if the router replies but this fails, the internet is down beyond the router.
4. `nslookup google.com` — if IP ping works but names don't, it's DNS (see [dns-not-resolving.md](dns-not-resolving.md)).
5. Confirm the user is on `Staff-WiFi`, not `Guest-WiFi`, if they need internal resources.
6. Toggle Wi-Fi off/on, or forget and rejoin the network.
7. Compare with another device — if everything is offline, it's the router/ISP.

## Root Cause Example
The office router had lost its ISP (WAN) connection. Laptops still connected to Wi-Fi and got local IPs, but nothing could reach the internet — gateway ping worked, `8.8.8.8` didn't.

## Resolution
Confirmed the ISP link was down (gateway reachable, internet not). Power-cycled the modem/router; ISP link came back and browsing resumed. If the ISP outage were external, this would be escalated.

## When to Escalate
- Router reachable but no internet for everyone → likely ISP outage → escalate to MSP/ISP.
- Router itself unreachable and won't recover on reboot → escalate.
- Repeated WAN drops → escalate for router/ISP investigation.

## User-Facing Response
> "Your Wi-Fi was connected, but the office's internet link had dropped. I restarted the connection and it's back online. This affected the whole office, not just your laptop."
