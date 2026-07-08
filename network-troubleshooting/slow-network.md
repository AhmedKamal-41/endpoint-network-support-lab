# Runbook: Slow Network

## Issue Summary
Browsing, file transfers, or cloud apps feel slow for one or more users. Level 1 isolates whether it's one device, the Wi-Fi, or the whole office internet link.

## Symptoms
- Pages load slowly or time out intermittently
- Video calls stutter or drop
- Large files copy very slowly to/from shares
- Speed varies by time of day or location in the office

## Possible Causes
- Weak Wi-Fi signal / distance from access point
- Too many devices saturating the internet link
- Large background downloads (updates, backups)
- Local device issue (high CPU/disk, malware)
- ISP degradation or router overload

## Commands to Run
```powershell
ping 192.168.1.1                              # latency to the router
ping 8.8.8.8 -n 20                            # latency/loss to the internet
tracert 8.8.8.8                               # where do delays start?
Test-NetConnection 8.8.8.8 -InformationLevel Detailed
Get-NetAdapter                                # link speed / adapter status
```

## Expected Output
Low, steady latency to the gateway (usually <5 ms) and reasonable internet latency with little/no packet loss:
```
Reply from 8.8.8.8: bytes=32 time=18ms TTL=118
...
Packets: Sent = 20, Received = 20, Lost = 0 (0% loss)
```
High latency or loss to the gateway = local/Wi-Fi issue. Fine to the gateway but bad beyond = internet/ISP.

## Troubleshooting Steps
1. `ping 192.168.1.1 -n 20` — high latency/loss here points to Wi-Fi or the local network, not the ISP.
2. `ping 8.8.8.8 -n 20` — compare. Good local, bad internet = ISP/router.
3. Check Wi-Fi signal; move closer to the access point or switch to `Staff-WiFi` if on guest.
4. On the laptop, open Task Manager → Network/Disk/CPU. A background download or 100% disk can mimic "slow internet."
5. Run a quick speed test and compare with the expected plan speed.
6. `tracert 8.8.8.8` to see where latency spikes (local hop vs. out on the internet).
7. Test another device in the same spot to separate "this laptop" from "this network."

## Root Cause Example
A large Windows Update and a cloud backup were running on several laptops at once, saturating the office internet link mid-morning. Individual devices were fine; the shared link was the bottleneck.

## Resolution
Identified the bandwidth-heavy tasks, rescheduled updates/backups to off-hours, and speeds returned to normal. Recommended the MSP stagger update windows going forward.

## When to Escalate
- Whole office is slow and it traces to the ISP/router → escalate to MSP/ISP.
- Consistent packet loss on the internet hops in `tracert` → escalate.
- Possible malware causing traffic on a device → escalate to security while isolating the device.

## User-Facing Response
> "The slowness was from several large updates and backups running at the same time and using up the office internet. I've moved those to run after hours, and things should feel much faster now."
