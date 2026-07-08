# Runbook: Browser Crashing or Freezing

## Issue Summary
The web browser (Chrome/Edge) crashes, freezes, or won't load pages properly. Usually caused by cache, extensions, too many tabs, or an outdated browser.

## Symptoms
- Browser closes unexpectedly / "Aw, Snap"
- Pages freeze or load partially
- Very slow, high memory use with many tabs
- One site breaks the browser (see [../network-troubleshooting/website-access-issue.md](../network-troubleshooting/website-access-issue.md))

## First Questions to Ask the User
- Which browser, and does it crash on all sites or one?
- When did it start? After an update or a new extension?
- How many tabs are usually open?
- Does another browser work fine?
- Any error message or code?

## Troubleshooting Steps
1. **Close and reopen** the browser; **restart the laptop** if it's been up a long time.
2. Try an **incognito/private window** — this disables extensions and ignores cache. If it's stable there, an extension or cache is the cause.
3. **Disable extensions** one by one (or all, then re-enable) to find a bad one.
4. **Clear cache and cookies** (keep passwords if the user relies on them).
5. **Update the browser** to the latest version and relaunch.
6. Check **memory** — dozens of tabs can exhaust RAM; close unused tabs. See [slow-laptop.md](slow-laptop.md).
7. If only one browser is affected, **reset** it to defaults or reinstall (with approval).
8. Confirm with the user across a few sites.

## Tools Used
- Browser settings (extensions, clear browsing data, about/version)
- Task Manager (memory), browser's own task manager (Shift+Esc in Chrome/Edge)

## Safe Commands (if applicable)
```powershell
# See how much memory the browser is using
Get-Process chrome, msedge -ErrorAction SilentlyContinue |
  Sort-Object WorkingSet -Descending |
  Select-Object Name, Id, @{n='Mem(MB)';e={[math]::Round($_.WorkingSet/1MB)}}
```
> Browser fixes are mostly in-app (cache/extensions/update). Commands just help spot memory pressure.

## Resolution
Example: Edge was crashing due to an outdated ad-blocker extension. Disabling that extension and updating the browser stopped the crashes; the user re-added a supported extension later.

## When to Escalate
- Crashes persist after cache clear, extension disable, and reinstall → escalate.
- Managed/enterprise browser policies causing issues → escalate to whoever manages the browser policy.
- Crash tied to a required web app → involve the app vendor/owner.

## Prevention Tips
- Keep the browser updated.
- Install only trusted, necessary extensions.
- Avoid keeping dozens of tabs open all day.
- Clear cache periodically if sites misbehave.
