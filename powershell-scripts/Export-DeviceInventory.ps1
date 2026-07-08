<#
.SYNOPSIS
    Export-DeviceInventory.ps1 - Export this device's key info to a CSV row.

.DESCRIPTION
    Collects computer name, serial number, OS, CPU, RAM, and disk info and
    writes it to a CSV file. Read-only collection; only writes the output CSV.

.WHY
    Speeds up updating the asset inventory. Run it on a machine to grab the
    hardware facts instead of typing them by hand. See asset-inventory-guide.

.PARAMETER OutputPath
    Where to save the CSV. Defaults to the user's Desktop.

.NOTES
    Level 1 IT Support Lab - QueensBridge Medical Office (fictional).
#>

param(
    [string]$OutputPath = "$env:USERPROFILE\Desktop\device-inventory.csv"
)

Write-Host "======== EXPORT DEVICE INVENTORY ========" -ForegroundColor Cyan

try {
    $os   = Get-CimInstance Win32_OperatingSystem
    $cs   = Get-CimInstance Win32_ComputerSystem
    $bios = Get-CimInstance Win32_BIOS
    $cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

    # Build a single record (one device = one row)
    $record = [PSCustomObject]@{
        DeviceName     = $env:COMPUTERNAME
        SerialNumber   = $bios.SerialNumber
        Manufacturer   = $cs.Manufacturer
        Model          = $cs.Model
        OSVersion      = "$($os.Caption) $($os.Version)"
        CPU            = $cpu.Name
        RAM_GB         = [math]::Round($cs.TotalPhysicalMemory / 1GB, 1)
        DiskSize_GB    = [math]::Round($disk.Size / 1GB, 1)
        DiskFree_GB    = [math]::Round($disk.FreeSpace / 1GB, 1)
        AssignedUser   = $env:USERNAME
        CollectedOn    = (Get-Date).ToString("yyyy-MM-dd")
    }

    # Show it on screen
    $record | Format-List

    # Save to CSV
    $record | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
    Write-Host "Saved inventory to: $OutputPath" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Could not export device inventory." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
