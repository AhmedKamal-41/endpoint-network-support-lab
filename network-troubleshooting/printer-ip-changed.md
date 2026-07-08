# Runbook: Network Printer IP Changed

## Issue Summary
A shared network printer (e.g. `PRN-FRONT-01`) stopped printing for one or more users. A common cause is the printer's IP address changing, so the print queue on the laptops points to the wrong address.

## Symptoms
- Jobs sit in the queue as "Error" or "Offline"
- "Printer not responding" / "unable to connect"
- The printer powers on and shows no error on its own panel
- Multiple people lose the same printer around the same time

## Possible Causes
- Printer was set back to DHCP and got a new IP
- Printer's static IP was changed or lost after a power outage
- Print queue on the laptop uses the old IP/port
- Printer is on a different network segment than expected

## Commands to Run
```powershell
ping 192.168.1.50                          # old/expected printer IP
Test-NetConnection 192.168.1.50 -Port 9100 # printer print port (RAW)
arp -a                                     # list IP-to-MAC on the network
Get-Printer                                # list installed printers (PowerShell)
Get-PrinterPort                            # show the IP/port each printer uses
```

## Expected Output
A reachable printer replies to ping and answers on port 9100:
```
Test-NetConnection 192.168.1.50 -Port 9100
TcpTestSucceeded : True
```
If ping to the expected IP fails but the printer is clearly on, its IP likely changed.

## Troubleshooting Steps
1. Confirm the printer is powered on and has no panel error.
2. Print the printer's **network/config page** from its own menu — it shows the current IP.
3. From a laptop, `ping` the expected IP (`192.168.1.50`). If it fails, the IP has changed.
4. Compare the config-page IP with what the print queue uses (`Get-PrinterPort`).
5. If different, update the printer port to the correct IP, or set the printer back to its **static IP** on the device.
6. Send a test print.
7. Repeat the port fix on other affected laptops (or update via print server/GPO if one exists).

## Root Cause Example
After a weekend power outage, `PRN-FRONT-01` came back on DHCP instead of its static IP and received `192.168.1.147`. Laptops still pointed to `192.168.1.50`, so every job errored.

## Resolution
Set the printer back to its static IP (`192.168.1.50`) on the device, confirmed `Test-NetConnection ... -Port 9100` succeeded, and test-printed successfully. Documented the static IP so it can be re-applied quickly next time.

## When to Escalate
- Printer needs static IP reconfiguration you can't perform (locked admin menu) → escalate to MSP.
- A shared print server/GPO manages the queues → escalate to server team to update centrally.
- Hardware fault on the printer (won't hold config, network port dead) → escalate for repair/replacement.

## User-Facing Response
> "The printer's network address had changed after the power outage, so your computer was sending jobs to the old address. I've reset it to the correct address and your test print worked. It should be reliable now."
