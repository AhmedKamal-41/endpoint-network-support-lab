# Runbook: DNS Not Resolving

## Issue Summary
A user can't reach websites or internal resources by name, but the internet connection itself appears to work. This usually points to a DNS (name-to-IP) problem rather than a full outage.

## Symptoms
- "This site can't be reached" / "server not found" in the browser
- Websites fail to load by name, but a known IP address works
- Email or the EHR client can't reach its server by hostname
- Some devices work; the affected one doesn't

## Possible Causes
- Wrong or unreachable DNS server on the laptop
- Corrupt local DNS cache
- DHCP handed out a bad DNS setting
- Router/ISP DNS temporarily down
- VPN changed DNS settings and didn't clean up

## Commands to Run
```powershell
ipconfig /all                       # check the DNS servers listed
nslookup google.com                 # test public name resolution
nslookup qbfiles01                  # test an internal name
ping 8.8.8.8                        # confirm internet works by IP
ipconfig /flushdns                  # clear the local DNS cache
Get-DnsClientServerAddress          # show configured DNS servers (PowerShell)
```

## Expected Output
A healthy `nslookup google.com` returns a server and one or more IP addresses:
```
Server:  UnKnown
Address:  192.168.1.1

Non-authoritative answer:
Name:    google.com
Addresses:  142.250.72.14
```
If `ping 8.8.8.8` succeeds but `nslookup google.com` fails, the problem is DNS, not the internet.

## Troubleshooting Steps
1. Confirm internet works by IP: `ping 8.8.8.8`. If this fails too, this is a broader connectivity issue — see [cannot-ping-gateway.md](cannot-ping-gateway.md).
2. Run `nslookup google.com`. If it fails, DNS is suspect.
3. Check `ipconfig /all` — note the DNS servers. Are they blank, wrong, or unreachable?
4. Flush the cache: `ipconfig /flushdns`, then retest.
5. Try a known-good DNS server: temporarily set DNS to `8.8.8.8` / `1.1.1.1` and retest.
6. If the user is on VPN, disconnect and retest — VPN can override DNS.
7. Compare with another laptop on the same network. If only one device fails, it's local; if all fail, it's the router/ISP.

## Root Cause Example
The laptop's DNS server was still set to an old VPN DNS address after the VPN disconnected. Public and internal names failed to resolve while raw IPs still worked.

## Resolution
Reset DNS to automatic (DHCP) or the correct DNS server, ran `ipconfig /flushdns`, and confirmed `nslookup google.com` resolved. Browsing returned to normal.

## When to Escalate
- All devices in the office can't resolve names (points to router/ISP DNS) → escalate to MSP/ISP.
- Internal DNS server (if present) is down → escalate to server team.
- Repeated DNS corruption tied to VPN → escalate to whoever manages the VPN config.

## User-Facing Response
> "Your internet connection is fine — the issue was in how your laptop looks up website names. I cleared and reset that, and everything is loading normally now. If it happens again, let me know and I'll check the network settings."
