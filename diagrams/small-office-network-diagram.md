# Small Office Network Diagram

Logical layout of the QueensBridge Medical Office (fictional) network: internet → router → Wi-Fi and wired devices, printers, shared folders, plus a remote VPN user. IP examples match [../sample-data/lab-environment.md](../sample-data/lab-environment.md).

```mermaid
graph TD
    ISP["Internet / ISP"]
    ROUTER["Office Router / Gateway<br/>192.168.1.1<br/>DHCP + DNS"]

    ISP --- ROUTER

    ROUTER --- STAFF["Staff-WiFi<br/>(internal access)"]
    ROUTER --- GUEST["Guest-WiFi<br/>(internet only, isolated)"]
    ROUTER --- SERVER["File Server / NAS<br/>QBFILES01"]
    ROUTER --- PRINTERS["Network Printers"]

    STAFF --- LT1["Laptops x15<br/>DHCP 192.168.1.100-199"]
    GUEST --- VISITOR["Patient / Visitor Devices"]

    PRINTERS --- P1["PRN-FRONT-01<br/>192.168.1.50"]
    PRINTERS --- P2["PRN-BILL-02<br/>192.168.1.51"]
    PRINTERS --- P3["PRN-BACK-03<br/>192.168.1.52"]

    SERVER --- SH1["HR share"]
    SERVER --- SH2["Finance share"]
    SERVER --- SH3["Operations share"]
    SERVER --- SH4["Management share"]

    REMOTE["Remote Employee<br/>(Home)"] -.VPN.-> ROUTER

    classDef net fill:#dbeafe,stroke:#1e40af,color:#1e3a8a;
    classDef dev fill:#dcfce7,stroke:#166534,color:#14532d;
    classDef sec fill:#fef9c3,stroke:#854d0e,color:#713f12;
    class ISP,ROUTER,STAFF,GUEST net;
    class LT1,VISITOR,P1,P2,P3,PRINTERS dev;
    class SERVER,SH1,SH2,SH3,SH4,REMOTE sec;
```

## Key Points
- **Router (192.168.1.1)** is the gateway, DHCP server, and DNS forwarder.
- **Staff-WiFi** reaches internal shares and printers; **Guest-WiFi** is internet-only and isolated.
- **Printers** use static IPs (`.50`–`.52`) so their addresses don't change.
- **Laptops** get DHCP addresses from `192.168.1.100`–`199`.
- **Shared folders** (HR, Finance, Operations, Management) live on `QBFILES01`.
- **Remote employees** reach internal resources over the **VPN** (dotted line).
