# Runbook: Cannot Ping the Gateway

## Issue Summary
The laptop can't reach its default gateway (the router, `192.168.1.1`). Without the gateway, there's no path off the local network — no internet and often no internal resources.

## Symptoms
- No internet and no access to shares/printers
- `ping 192.168.1.1` times out
- Wi-Fi/Ethernet shows connected but "No internet"
- May have a valid-looking IP or a `169.254.x.x` address

## Possible Causes
- Physical problem: unplugged/faulty cable, bad port, Wi-Fi dropped
- No valid IP from DHCP (see [dhcp-issue.md](dhcp-issue.md))
- Wrong subnet mask / static IP on a different network
- Router down or the switch/port is dead
- Adapter disabled or driver problem

## Commands to Run
```powershell
ipconfig /all                       # confirm IP, subnet, and gateway values
ping 192.168.1.1                    # can we reach the router?
Get-NetIPConfiguration              # PowerShell view of adapter + gateway
Get-NetAdapter                      # is the adapter Up? link speed?
Test-NetConnection 192.168.1.1      # PowerShell reachability test
```

## Expected Output
Healthy adapter with a matching subnet, and the gateway replies:
```
IPv4 Address. . . : 192.168.1.112
Subnet Mask . . . : 255.255.255.0
Default Gateway . : 192.168.1.1

Reply from 192.168.1.1: bytes=32 time=2ms TTL=64
```
Timeouts to `192.168.1.1` mean the local path to the router is broken.

## Troubleshooting Steps
1. `ipconfig /all` — do we have a valid IP on the right subnet with a gateway listed? If it's `169.254.x.x`, go to [dhcp-issue.md](dhcp-issue.md).
2. Check the physical link: reseat the Ethernet cable / try another port, or verify Wi-Fi is actually associated.
3. `Get-NetAdapter` — confirm the adapter is **Up**, not disabled. Re-enable if needed.
4. `ping 192.168.1.1`. Still failing? Reboot to reset the adapter and retest.
5. If the laptop has a **static** IP with the wrong subnet/gateway, switch it back to automatic (DHCP).
6. Test another device on the same cable/port/Wi-Fi. If it also can't reach the gateway, the router/switch is the problem.

## Root Cause Example
The desk network cable had been half-pulled out during cleaning. The adapter showed a self-assigned `169.254` address and couldn't reach the gateway. Reseating the cable restored a DHCP lease and gateway access.

## Resolution
Reseated the cable, ran `ipconfig /renew`, confirmed a valid IP and a successful `ping 192.168.1.1`, and internet returned. Documented the loose cable.

## When to Escalate
- Multiple devices can't reach the gateway → router/switch problem → escalate to MSP.
- Router unresponsive after power cycle → escalate.
- Suspected failed switch port or cabling in the wall → escalate for on-site network work.

## User-Facing Response
> "Your network cable had come loose, so your laptop couldn't reach the office router at all. I reconnected it and your internet and shared drives are working again."
