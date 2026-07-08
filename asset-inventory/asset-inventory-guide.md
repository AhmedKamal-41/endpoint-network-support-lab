# Asset Inventory Guide

How QueensBridge Medical Office (fictional lab) tracks its IT devices, keeps the tracker current, flags devices for follow-up, and uses the tracker during onboarding and offboarding.

The live tracker is **[it-asset-inventory.csv](it-asset-inventory.csv)**.

---

## Why Track Assets

A device inventory answers the questions IT gets asked constantly:

- **Who** has which laptop?
- **What** is on it, and is it secure and up to date?
- **When** does its warranty end?
- **What** is currently wrong with it, and is there an open ticket?
- Is it **in use, being repaired, in stock, or ready to return?**

Without a tracker, devices get lost, warranties lapse, security gaps go unnoticed, and offboarding leaves company data on unreturned laptops.

## What Each Column Means

| Column | Meaning |
|---|---|
| Asset Tag | Unique ID IT assigns (e.g. `QB-LT-001`). Physical sticker on the device. |
| Device Name | Windows computer name (matches the hostname you see with `hostname`). |
| Serial Number | Manufacturer serial — used for warranty and support claims. |
| Assigned User | Person currently responsible for the device. |
| Department | HR / Finance / Operations / Management / IT. |
| Device Type | Laptop, desktop, tablet, etc. |
| OS Version | Windows edition and version (helps spot machines needing upgrades). |
| Warranty Expiration | Date manufacturer coverage ends. |
| Condition | Good / Fair / Needs Repair. |
| Last Checked | Date IT last verified the device. |
| Installed Apps | Key software (M365, EHR client, VPN, EDR, etc.). |
| Security Status | Compliant / Needs Update / At Risk. |
| Current Issue | Active problem, if any. |
| Ticket History | Related ticket numbers and status. |
| Return Status | In Use / In Stock / Pending Repair / Offboarding Required. |

## How to Update the Tracker

1. **Open the CSV** in Excel, Google Sheets, or a text editor.
2. **Find the row** by Asset Tag or Assigned User.
3. **Edit only the changed fields** (e.g. set `Current Issue`, update `Security Status`, add a ticket to `Ticket History`).
4. **Update `Last Checked`** to today's date whenever you touch a device.
5. **Save as CSV** (keep the same file name and column order).
6. For a fresh export straight from a machine, run [../powershell-scripts/Export-DeviceInventory.ps1](../powershell-scripts/Export-DeviceInventory.ps1).

> Tip: keep dates in `YYYY-MM-DD` format so the sheet sorts correctly.

## How to Identify Devices Needing Follow-Up

Filter or sort the sheet to catch problems early:

- **Security Status = `Needs Update` or `At Risk`** → schedule updates or investigate the EDR agent.
- **Condition = `Needs Repair`** → open/confirm a repair ticket; arrange a loaner.
- **Return Status = `Pending Repair`, `Offboarding Required`, or `In Stock`** → action needed.
- **Warranty Expiration within 60 days** → plan replacement or extended coverage.
- **Current Issue is not `None`** → confirm there's an open ticket for it.
- **Last Checked older than ~90 days** → device is overdue for a health check.

Example follow-ups from the current lab data:

| Device | Flag | Action |
|---|---|---|
| QB-LT-003 | Missing updates | Push Windows updates, then set Security Status = Compliant |
| QB-LT-004 | Low disk space | Run [Find-LargeFiles.ps1](../powershell-scripts/Find-LargeFiles.ps1) + [Clear-TempFiles-Safe.ps1](../powershell-scripts/Clear-TempFiles-Safe.ps1) |
| QB-LT-007 | Battery swelling | Escalated repair — stop using, arrange loaner |
| QB-LT-012 | EDR not reporting | Escalated to security — reinstall/repair agent |
| QB-LT-014 | User leaving 2026-07-15 | Begin offboarding checklist |

## Using the Tracker During Onboarding

1. Pick a device with **Return Status = `In Stock`** (e.g. `QB-SPARE-01`).
2. Assign it: set **Assigned User**, **Department**, and **Return Status = `In Use`**.
3. Confirm software: M365, EHR/HR/Billing app as needed, VPN, EDR.
4. Verify **Security Status = `Compliant`** (updates applied, EDR reporting).
5. Set **Condition** and **Last Checked** to today.
6. Note the setup ticket in **Ticket History**.

## Using the Tracker During Offboarding

When a user leaves (e.g. QB-LT-014, user leaving 2026-07-15):

1. Set **Return Status = `Offboarding Required`** and open a ticket.
2. **Collect the device** on or before the last day.
3. **Back up** any needed files to the correct department share.
4. **Disable the user account** and remove VPN/app access (coordinate with the account owner).
5. **Wipe / re-image** the laptop back to the base image.
6. Clear **Assigned User** (set to `Unassigned`), set **Department = IT**.
7. Set **Return Status = `In Stock`** so it's ready for the next hire.
8. Update **Last Checked** and record the offboarding ticket.

## Good Habits

- Update the tracker **at the time** you touch a device, not later.
- Never store passwords or other secrets in the inventory.
- Keep Asset Tags unique and matching the physical sticker.
- Review the whole sheet on a set schedule (e.g. monthly) to catch stale entries.
