# Lab Environment — QueensBridge Medical Office

> **Fictional environment.** QueensBridge Medical Office is not a real company. All names, asset tags, IP addresses, and users below are made up for training and portfolio purposes. No real data or credentials are used anywhere in this lab.

## Company Overview

**QueensBridge Medical Office** is a small medical office with about 15 staff across four departments. It runs a simple Windows-based environment supported by a single Level 1 IT technician (me, in this lab), who handles first response and escalates deeper network or server problems to a managed service provider (MSP).

| Item | Value |
|---|---|
| Company | QueensBridge Medical Office (fictional) |
| Staff | ~15 |
| Departments | HR, Finance, Operations, Management |
| IT support model | Level 1 first response + escalation to MSP |
| Ticketing | Simulated (documented in runbooks & inventory) |

## Endpoints

- **15 Windows laptops** — mix of Windows 10 and Windows 11
- Standard image includes: Microsoft 365, a browser, the EHR/practice client, VPN client, antivirus/EDR agent
- Devices are tracked in [../asset-inventory/it-asset-inventory.csv](../asset-inventory/it-asset-inventory.csv)

## Printers

| Printer | Location | Type | Example IP |
|---|---|---|---|
| PRN-FRONT-01 | Front desk | Network laser (shared) | 192.168.1.50 |
| PRN-BILL-02 | Billing / Finance | Network laser | 192.168.1.51 |
| PRN-BACK-03 | Back office | Network multifunction | 192.168.1.52 |

Printers use **static IPs** so their addresses don't change. When a printer is accidentally set back to DHCP, its IP can change and printing breaks — see [../network-troubleshooting/printer-ip-changed.md](../network-troubleshooting/printer-ip-changed.md).

## Network

| Item | Value (example) |
|---|---|
| Office router / gateway | 192.168.1.1 |
| Subnet | 192.168.1.0/24 (255.255.255.0) |
| DHCP range | 192.168.1.100 – 192.168.1.199 |
| Static devices | Router, printers, and network gear below .100 |
| DNS | Provided by router / ISP (e.g. 192.168.1.1, 8.8.8.8) |
| Internet | Single business ISP connection |

### Wi-Fi Networks

- **Staff-WiFi** — for staff laptops; full access to internal shares and printers
- **Guest-WiFi** — for patients/visitors; internet only, isolated from internal resources

### VPN

- **1 VPN connection** for remote employees to reach internal shared folders securely from home
- VPN issues are triaged at Level 1 and escalated to the MSP if the VPN server itself is down — see [../network-troubleshooting/vpn-not-connecting.md](../network-troubleshooting/vpn-not-connecting.md)

## Shared Folders

Department shares live on a small file server / NAS and are reached over the network (SMB). Access is by department.

| Share | Path (example) | Access |
|---|---|---|
| HR | `\\QBFILES01\HR` | HR + Management |
| Finance | `\\QBFILES01\Finance` | Finance + Management |
| Operations | `\\QBFILES01\Operations` | Operations staff |
| Management | `\\QBFILES01\Management` | Management only |

Shared folder problems are covered in [../network-troubleshooting/shared-folder-unreachable.md](../network-troubleshooting/shared-folder-unreachable.md).

## IT Support Model

1. **Level 1 (this lab):** First response for all tickets — endpoints, printers, Wi-Fi, VPN, shares, accounts. Runs standard diagnostics, applies documented fixes, and communicates with users.
2. **Escalation (MSP / Level 2+):** Server outages, router/switch config, ISP problems, VPN server down, backup/restore, security incidents.

Each runbook in this lab includes a **"When to Escalate"** section so the boundary between Level 1 and escalation is always clear.

## Example IP Plan (Reference)

| Range | Use |
|---|---|
| 192.168.1.1 | Router / default gateway |
| 192.168.1.2 – 192.168.1.49 | Reserved / network gear |
| 192.168.1.50 – 192.168.1.52 | Printers (static) |
| 192.168.1.53 – 192.168.1.99 | Reserved static |
| 192.168.1.100 – 192.168.1.199 | DHCP pool (laptops) |
| 192.168.1.200 – 192.168.1.254 | Reserved |
