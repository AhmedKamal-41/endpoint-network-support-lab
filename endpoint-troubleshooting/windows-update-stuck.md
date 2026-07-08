# Runbook: Windows Update Stuck or Failing

## Issue Summary
Windows Update is stuck downloading/installing, fails with an error, or keeps offering the same update. Level 1 works through safe, standard fixes before escalating.

## Symptoms
- Update stuck at a percentage for a long time
- Error code (e.g. 0x800xxxxx) when updating
- "We couldn't complete the updates, undoing changes"
- Same update offered repeatedly

## First Questions to Ask the User
- How long has it been stuck? (Some updates are genuinely slow.)
- Is there an error code on screen?
- How much free disk space is there?
- Has the laptop been restarted since the update started?
- Is it on a stable network / not mid-VPN?

## Troubleshooting Steps
1. **Give it time** — large updates can sit at a percentage for a while. Confirm it's truly stuck (no disk activity for a long period).
2. **Restart** the laptop; many "stuck" updates finish or roll back cleanly after a reboot.
3. Check **free disk space** — updates need several GB. If low, see [low-disk-space.md](low-disk-space.md).
4. Confirm a stable **internet connection**; disconnect VPN during the update if needed.
5. Run the built-in **Windows Update Troubleshooter** (Settings → System → Troubleshoot).
6. If it still fails, clear the update cache (standard fix):
   - Stop the update services, rename `SoftwareDistribution`, restart services (see command block).
7. Retry the update and note the result / error code.

## Tools Used
- Settings → Windows Update, Update Troubleshooter
- Services (`services.msc`)
- PowerShell (elevated) for cache reset

## Safe Commands (if applicable)
```powershell
# Run PowerShell as Administrator. Standard Windows Update cache reset.
Stop-Service wuauserv, bits -Force
Rename-Item "$env:SystemRoot\SoftwareDistribution" "SoftwareDistribution.old" -ErrorAction SilentlyContinue
Start-Service wuauserv, bits
# Then re-check for updates in Settings.
```
> This only renames the update cache folder (Windows rebuilds it). It does not touch user files.

## Resolution
Example: An update was stuck because the drive was nearly full. Freeing ~8 GB and resetting the update cache let the update download and install cleanly on the next check.

## When to Escalate
- Persistent failure with the same error code after cache reset → escalate with the code and logs.
- Update loop that keeps rolling back → escalate (may need in-place repair/feature update).
- Suspected corrupted OS components → escalate to server/imaging team for repair or re-image.

## Prevention Tips
- Keep enough free disk space for updates.
- Install updates during downtime, not right before important work.
- Restart weekly so pending updates finish.
- Don't run updates over VPN or unstable Wi-Fi when avoidable.
