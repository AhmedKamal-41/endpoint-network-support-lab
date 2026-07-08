<#
.SYNOPSIS
    Check-NetworkStatus.ps1 - Quick network health check for a Windows device.

.DESCRIPTION
    Shows the active IP address, gateway, and DNS servers, then tests
    connectivity to the gateway, the internet (8.8.8.8), and name resolution.
    Read-only and safe.

.WHY
    Covers the first three questions on almost every network ticket: do I have
    an IP, can I reach the router, and can I reach/resolve the internet?

.NOTES
    Level 1 IT Support Lab - QueensBridge Medical Office (fictional).
#>

Write-Host "=========== NETWORK STATUS CHECK ===========" -ForegroundColor Cyan
Write-Host "Computer: $env:COMPUTERNAME" -ForegroundColor Cyan
Write-Host ""

try {
    # Find the active configuration (has a gateway = the connection in use)
    $config = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | Select-Object -First 1

    if ($null -eq $config) {
        Write-Host "No active network connection with a default gateway found." -ForegroundColor Yellow
        return
    }

    $ip      = $config.IPv4Address.IPAddress
    $gateway = $config.IPv4DefaultGateway.NextHop
    $dns     = ($config.DNSServer | Where-Object { $_.AddressFamily -eq 2 }).ServerAddresses -join ', '

    Write-Host "Interface : $($config.InterfaceAlias)"
    Write-Host "IP Address: $ip"
    Write-Host "Gateway   : $gateway"
    Write-Host "DNS       : $dns"
    Write-Host ""

    # Test 1: reach the gateway
    Write-Host "Testing gateway ($gateway)..."
    if (Test-Connection -ComputerName $gateway -Count 2 -Quiet) {
        Write-Host "   Gateway reachable." -ForegroundColor Green
    } else {
        Write-Host "   Cannot reach gateway - see cannot-ping-gateway runbook." -ForegroundColor Yellow
    }

    # Test 2: reach the internet by IP
    Write-Host "Testing internet (8.8.8.8)..."
    if (Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet) {
        Write-Host "   Internet reachable by IP." -ForegroundColor Green
    } else {
        Write-Host "   Cannot reach internet - possible ISP/router issue." -ForegroundColor Yellow
    }

    # Test 3: DNS name resolution
    Write-Host "Testing DNS resolution (google.com)..."
    try {
        $null = Resolve-DnsName -Name "google.com" -ErrorAction Stop
        Write-Host "   DNS resolution working." -ForegroundColor Green
    } catch {
        Write-Host "   DNS not resolving - see dns-not-resolving runbook." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "ERROR: Could not complete network check." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host ""
Write-Host "Network check complete." -ForegroundColor Cyan
