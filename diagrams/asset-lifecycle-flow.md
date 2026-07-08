# Asset Lifecycle Flow

The life of a device at QueensBridge Medical Office (fictional), from purchase to retirement, and how the asset inventory is updated at each stage. See [../asset-inventory/asset-inventory-guide.md](../asset-inventory/asset-inventory-guide.md).

```mermaid
flowchart LR
    A["Procurement<br/>buy device"] --> B["Intake<br/>tag + add to inventory<br/>Return Status: In Stock"]
    B --> C["Deploy / Onboarding<br/>assign user + software<br/>Status: In Use"]
    C --> D["In Use<br/>health checks, updates,<br/>tickets, security status"]

    D --> E{"Issue?"}
    E -->|"Repair needed"| F["Pending Repair<br/>loaner if needed"]
    F --> D
    E -->|"None"| D

    D --> G{"User leaving?"}
    G -->|"Yes"| H["Offboarding Required<br/>collect, backup, disable access"]
    H --> I["Wipe / re-image<br/>Return Status: In Stock"]
    I --> C

    D --> J{"End of life?"}
    J -->|"Yes"| K["Retire / Dispose<br/>secure wipe + remove from inventory"]

    classDef buy fill:#dbeafe,stroke:#1e40af,color:#1e3a8a;
    classDef use fill:#dcfce7,stroke:#166534,color:#14532d;
    classDef decision fill:#fef9c3,stroke:#854d0e,color:#713f12;
    classDef end fill:#fee2e2,stroke:#991b1b,color:#7f1d1d;
    class A,B buy;
    class C,D,F,H,I use;
    class E,G,J decision;
    class K end;
```

## Stages & Inventory Updates
| Stage | Inventory action |
|---|---|
| Procurement | Create the record when the device arrives |
| Intake | Assign an Asset Tag; set Return Status = **In Stock** |
| Onboarding | Set Assigned User, Department, apps; Return Status = **In Use** |
| In Use | Keep Condition, Security Status, Current Issue, Last Checked current |
| Repair | Return Status = **Pending Repair**; provide a loaner |
| Offboarding | Return Status = **Offboarding Required** → collect, back up, disable access |
| Redeploy | Wipe/re-image → **In Stock** for the next hire |
| Retirement | Secure wipe, then remove from active inventory |
