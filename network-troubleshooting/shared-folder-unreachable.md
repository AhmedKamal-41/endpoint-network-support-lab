# Runbook: Shared Folder Unreachable

## Issue Summary
A user can't open a department shared folder (e.g. `\\QBFILES01\Finance`). The problem is usually network access, permissions, or the file server itself.

## Symptoms
- "Windows cannot access \\QBFILES01\Finance"
- Mapped drive shows a red X / disconnected
- Prompted for credentials repeatedly
- Some shares open, others don't

## Possible Causes
- User isn't on the network / VPN (remote)
- File server or NAS is down or unreachable
- User lacks permission to that department's share
- Mapped drive using an old server name/IP
- Name resolution failing (see [dns-not-resolving.md](dns-not-resolving.md))

## Commands to Run
```powershell
ping QBFILES01                              # is the file server reachable by name?
Test-NetConnection QBFILES01 -Port 445      # SMB file-sharing port
nslookup QBFILES01                          # does the server name resolve?
net use                                     # list current mapped drives
Get-SmbMapping                              # PowerShell view of SMB mappings
```

## Expected Output
Server resolves and answers on the SMB port:
```
Test-NetConnection QBFILES01 -Port 445
TcpTestSucceeded : True
```
Then `\\QBFILES01\Finance` should open in File Explorer (subject to permissions).

## Troubleshooting Steps
1. Confirm the user is on the office network or VPN. Remote users must connect the VPN first — see [vpn-not-connecting.md](vpn-not-connecting.md).
2. `ping QBFILES01`. If it fails, check name resolution with `nslookup`; try the server IP directly.
3. `Test-NetConnection QBFILES01 -Port 445`. If this fails but ping works, SMB is blocked or the service is down.
4. Try opening `\\QBFILES01\Finance` directly by UNC path.
5. If prompted for credentials or "access denied," check whether the user's department actually has access to that share.
6. Remap a stale drive: `net use` to view, remove the bad mapping, remap to the correct path.
7. Test with another user who normally has access — if they fail too, the server is the issue.

## Root Cause Example
The user moved from Operations to Finance but had not been added to the Finance share's permissions. The path was reachable (port 445 succeeded), but access was denied.

## Resolution
Confirmed connectivity was fine and requested the Finance share permission for the user (via the share/account owner). Once added, the folder opened normally. Remapped the drive so it reconnects at login.

## When to Escalate
- File server/NAS unreachable for everyone (`ping`/port 445 fail broadly) → escalate to server team.
- Permission changes on department shares that require admin rights → escalate to the resource owner / server admin.
- SMB service down or share missing on the server → escalate.

## User-Facing Response
> "Your connection to the file server was working — the issue was that your account hadn't been granted access to the Finance folder after your move. I requested that access and you can open it now."
