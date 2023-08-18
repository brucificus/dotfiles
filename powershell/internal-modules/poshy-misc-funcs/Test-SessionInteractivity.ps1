
#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Test-SessionInteractivity {
    [CmdletBinding()]
    param()

    if (-not [Environment]::UserInteractive) {
        return $false
    }

    [string[]] $pwshArgs = [Environment]::GetCommandLineArgs()

    if ($pwshArgs -icontains '-NonInteractive') {
        return $false
    } elseif ($pwshArgs -icontains '-Command') {
        return $false
    } elseif ($pwshArgs -icontains '-EncodedCommand') {
        return $false
    } elseif ($pwshArgs -icontains '-File') {
        return $false
    } elseif ($pwshArgs -icontains '-NoWindow') {
        return $false
    }

    return $true
}
