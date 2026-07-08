# Runbook: Duplicate IP Address Conflict

## Issue Summary
Two devices ended up with the same IP address. Windows detects the conflict and drops or limits network access on one or both devices.

## Symptoms
- "Windows has detected an IP address conflict" popup
- Intermittent connectivity that drops and returns
- A device works, then loses network when the other one comes online
- Often involves a static device (printer/server) vs. a DHCP laptop

## Possible Causes
- A static IP was set inside the DHCP pool range
- Two devices manually configured with the same static IP
- DHCP server handed out an address that's already statically in use
- A device came back from sleep and grabbed a taken lease

## Commands to Run
```powershell
ipconfig /all                       # see the current IP and check for conflict
arp -a                              # map IPs to MAC addresses on the segment
ping <conflicting-ip>               # is the address answering?
ipconfig /release                   # drop the conflicting lease
ipconfig /renew                     # request a fresh address
```

## Expected Output
`arp -a` should show each IP tied to one MAC. During a conflict you may see the same IP associated with unexpected hardware, or Windows reports the conflict directly:
```
Windows has detected an IP address conflict.
Another computer on this network has the same IP address as this computer.
```

## Troubleshooting Steps
1. Read the conflict message — note the IP in question.
2. On the affected laptop, `ipconfig /release` then `ipconfig /renew` to pull a new DHCP address. This often clears a laptop-vs-laptop conflict instantly.
3. Use `arp -a` to identify the other device holding that IP (match the MAC to a known device).
4. If a **static** device (printer/server) is inside the DHCP range, move it to a reserved static address **outside** the pool (e.g. below `.100`) — see the IP plan in [../sample-data/lab-environment.md](../sample-data/lab-environment.md).
5. Consider a DHCP **reservation** for devices that should always keep the same IP.
6. Confirm the conflict warning is gone and connectivity is stable.

## Root Cause Example
A newly added printer was manually given `192.168.1.150`, which was inside the DHCP pool (100–199). DHCP later leased the same `.150` to a laptop, causing a conflict whenever both were on.

## Resolution
Moved the printer to a static address outside the pool (`192.168.1.50`) and added a DHCP reservation as backup. Renewed the laptop's lease. The conflict warnings stopped and both devices stayed online.

## When to Escalate
- The conflicting static device is infrastructure you can't reconfigure → escalate to MSP.
- DHCP pool/reservation changes require router admin access → escalate.
- Repeated conflicts suggest a DHCP scope design problem → escalate for review.

## User-Facing Response
> "Two devices were accidentally using the same network address, which kept knocking you offline. I gave the other device a fixed, separate address and refreshed yours. Your connection is stable now."
