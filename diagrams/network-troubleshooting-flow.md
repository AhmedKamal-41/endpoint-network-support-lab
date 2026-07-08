# Network Troubleshooting Flow

A decision tree for "no internet / can't reach something" tickets. It works outward from the laptop: IP → gateway → internet → DNS. The first failing step points to the right runbook.

```mermaid
flowchart TD
    A["User: no internet / can't connect"] --> B["ipconfig /all<br/>Do we have a valid IP?"]
    B -->|"No / 169.254.x.x"| C["DHCP problem<br/>dhcp-issue.md"]
    B -->|"Yes"| D["ping 192.168.1.1<br/>Gateway reachable?"]

    D -->|"No"| E["Local network / gateway<br/>cannot-ping-gateway.md"]
    D -->|"Yes"| F["ping 8.8.8.8<br/>Internet reachable by IP?"]

    F -->|"No"| G["ISP / router internet down<br/>wifi-connected-no-internet.md"]
    F -->|"Yes"| H["nslookup google.com<br/>Names resolve?"]

    H -->|"No"| I["DNS problem<br/>dns-not-resolving.md"]
    H -->|"Yes"| J{"What is the user<br/>actually trying to reach?"}

    J -->|"One website"| K["website-access-issue.md"]
    J -->|"Shared folder"| L["shared-folder-unreachable.md"]
    J -->|"VPN / remote"| M["vpn-not-connecting.md"]
    J -->|"Printer"| N["printer-ip-changed.md"]
    J -->|"Just slow"| O["slow-network.md"]

    classDef start fill:#dbeafe,stroke:#1e40af,color:#1e3a8a;
    classDef test fill:#dcfce7,stroke:#166534,color:#14532d;
    classDef fix fill:#fee2e2,stroke:#991b1b,color:#7f1d1d;
    classDef decision fill:#fef9c3,stroke:#854d0e,color:#713f12;
    class A start;
    class B,D,F,H test;
    class C,E,G,I,K,L,M,N,O fix;
    class J decision;
```

## How to Use
1. Work **top to bottom** — don't skip steps. Each check narrows the cause.
2. The **first failing check** tells you which runbook to open.
3. If everything passes but a specific resource fails, jump to that resource's runbook.
4. Also see [duplicate-ip-address.md](../network-troubleshooting/duplicate-ip-address.md) if you see IP-conflict warnings.
