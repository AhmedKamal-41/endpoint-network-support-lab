# Runbook: DHCP Issue (No / Bad IP Address)

## Issue Summary
A laptop can't get a valid IP address from the DHCP server, so it has no working network access. Often it shows a `169.254.x.x` (APIPA) self-assigned address, which means "I asked for an IP and got no answer."

## Symptoms
- No internet or network on one device
- IP address starts with `169.254.` (APIPA)
- "No internet, secured" on Wi-Fi
- Other devices on the same network work fine

## Possible Causes
- DHCP server / router not responding
- DHCP pool exhausted (all addresses in use)
- Faulty cable or Wi-Fi association
- DHCP disabled on the adapter (set to a bad static IP)
- Network adapter driver glitch

## Commands to Run
```powershell
ipconfig /all                       # look for 169.254.x.x or a missing IP
ipconfig /release                   # give back the current lease
ipconfig /renew                     # request a new lease from DHCP
Get-NetIPConfiguration              # PowerShell view of IP, gateway, DNS
ping 192.168.1.1                    # test the gateway once you have an IP
```

## Expected Output
A healthy device gets an address from the DHCP pool:
```
IPv4 Address. . . . . . . . . . . : 192.168.1.112
Subnet Mask . . . . . . . . . . . : 255.255.255.0
Default Gateway . . . . . . . . . : 192.168.1.1
DHCP Enabled. . . . . . . . . . . : Yes
```
A `169.254.x.x` address means DHCP failed.

## Troubleshooting Steps
1. Run `ipconfig /all`. If you see `169.254.x.x`, DHCP didn't respond.
2. Confirm the adapter is set to obtain an IP automatically (not a leftover static IP).
3. Renew the lease: `ipconfig /release` then `ipconfig /renew`.
4. Check the physical link — reseat the Ethernet cable, or forget/reconnect Wi-Fi.
5. Reboot the laptop (clears adapter state) and recheck `ipconfig /all`.
6. If the device still gets `169.254.x.x`, test another device on the same port/Wi-Fi. If it also fails, the DHCP server/router is the problem.

## Root Cause Example
The DHCP pool (192.168.1.100–199) was fully used because several old leases hadn't expired. The laptop got no address until a lease freed up / the pool was widened.

## Resolution
`ipconfig /release` + `/renew` pulled a valid address (192.168.1.112) once a lease was available. Confirmed gateway ping and internet worked. For the pool exhaustion itself, escalated to the MSP to widen the DHCP range / shorten lease time.

## When to Escalate
- Multiple devices can't get an IP (DHCP server / pool problem) → escalate to MSP.
- DHCP pool needs to be resized or lease time changed → escalate (router config).
- Suspected failing router/switch → escalate.

## User-Facing Response
> "Your laptop wasn't getting a network address automatically. I refreshed it and it now has a proper connection. This was a network-side hiccup, not a problem with your laptop."
