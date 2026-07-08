# Endpoint Support Flow

How a ticket moves through Level 1 support at QueensBridge Medical Office (fictional), from the user reporting an issue to resolution or escalation.

```mermaid
flowchart TD
    A["User reports issue"] --> B["Log ticket<br/>capture details + asset tag"]
    B --> C["Ask first questions<br/>when started? what changed?"]
    C --> D["Run Basic-Endpoint-Triage.ps1<br/>+ pick the right runbook"]
    D --> E{"Can Level 1<br/>resolve it?"}

    E -->|Yes| F["Apply documented fix"]
    F --> G["Verify with the user"]
    G --> H["Update asset inventory<br/>+ close ticket"]

    E -->|No| I["Gather logs / diagnostics"]
    I --> J["Escalate to MSP / Level 2<br/>server, network, hardware"]
    J --> K["Track until resolved"]
    K --> H

    H --> L["Send user-facing response<br/>plain-language summary"]

    classDef start fill:#dbeafe,stroke:#1e40af,color:#1e3a8a;
    classDef action fill:#dcfce7,stroke:#166534,color:#14532d;
    classDef decision fill:#fef9c3,stroke:#854d0e,color:#713f12;
    classDef esc fill:#fee2e2,stroke:#991b1b,color:#7f1d1d;
    class A start;
    class B,C,D,F,G,H,I,L action;
    class E decision;
    class J,K esc;
```

## Notes
- **Level 1** owns first response: triage, documented fixes, and user communication.
- **Escalation** goes to the MSP for servers, routers/switches, ISP, VPN server, and hardware repair.
- Every ticket ends with the **asset inventory updated** and a **plain-language response** to the user.
