# Runbook: Single Website Won't Load

## Issue Summary
Everything works except one specific website or web app. Because general internet is fine, this is usually about that one site, its address, or a local block — not the office connection.

## Symptoms
- One site won't load; other sites are fine
- Error like "can't reach this page" or a security warning
- Site works on a phone (cellular) but not the office laptop
- Works for some staff but not others

## Possible Causes
- The website itself is down or slow
- DNS cache has a stale/bad record for that site
- Browser cache/cookies or an extension breaking the site
- Site blocked by content filter/firewall (may be intentional)
- Certificate/date-time error on the laptop

## Commands to Run
```powershell
nslookup thesite.com                          # does the name resolve?
ping thesite.com                              # basic reachability (some sites block ping)
Test-NetConnection thesite.com -Port 443      # can we reach it over HTTPS?
tracert thesite.com                           # where does the path stop?
ipconfig /flushdns                            # clear stale DNS entries
```

## Expected Output
Name resolves and HTTPS is reachable:
```
Test-NetConnection thesite.com -Port 443
TcpTestSucceeded : True
```
If DNS resolves and port 443 succeeds but the browser still fails, suspect the browser (cache/extension) or the site itself.

## Troubleshooting Steps
1. Confirm other sites work — this narrows it to the one site.
2. `nslookup thesite.com` — does it resolve? If not, try `ipconfig /flushdns` and retest, or see [dns-not-resolving.md](dns-not-resolving.md).
3. `Test-NetConnection thesite.com -Port 443` — reachable? If it fails everywhere, the site may be down or blocked.
4. Try the site in an **incognito/private** window to bypass cache/cookies/extensions.
5. Try a different browser. If it works there, the original browser's cache/extension is the culprit — clear cache or disable extensions.
6. Check the laptop's date/time — a wrong clock causes certificate errors.
7. Verify the site isn't intentionally blocked by the office content filter (confirm with policy).
8. Check whether the site is down for everyone (use an external "is it down" check from another network/phone).

## Root Cause Example
A stale DNS entry pointed the site to an old server IP after the site migrated hosts. Other sites were unaffected. Flushing DNS resolved the correct address and the site loaded.

## Resolution
Ran `ipconfig /flushdns`, re-resolved the site to the correct IP, and confirmed it loaded. Verified in a normal browser window. For a browser-cache case, clearing cache/disabling the bad extension would be the fix.

## When to Escalate
- Site is blocked by the office firewall/content filter and needs to be allowed → escalate to the MSP/policy owner.
- The website itself is down (confirmed externally) → nothing to fix locally; inform the user / contact the vendor.
- Certificate issues tied to office proxy/security tooling → escalate.

## User-Facing Response
> "Your internet was fine — your laptop had an outdated address saved for that one site. I refreshed it and the page loads correctly now. Everything else was unaffected."
