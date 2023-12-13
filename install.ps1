#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-LinkCapability)) {
    if ($IsWindows) {
        Write-Error "This script requires filesystem link capabilities. Please run this script in an elevated PowerShell session, or enable Developer Mode in Windows Settings."
    } else {
        Write-Error "This script requires filesystem link capabilities. Please run this script in an elevated PowerShell session."
    }
    return
}

Set-Location $PSScriptRoot

$dotbot_dir = "dotbot"
git submodule update --quiet --init --force --checkout --depth 1 --recursive $dotbot_dir

# folders_to_relink = @()
# folders_to_relink | Where-Object { -not (Test-ReparsePoint $_) } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

function run_dotbot {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $config_file
    )
    foreach ($python in ('python', 'python3', 'python2')) {
        # Python redirects to Microsoft Store in Windows 10 when not installed
        if (& { $ErrorActionPreference = "SilentlyContinue"
                ![string]::IsNullOrEmpty((&$python -V))
                $ErrorActionPreference = "Stop" }) {
            $python_bin = $python
            break
        }
    }
    if (-not $python_bin) {
        throw "Cannot find Python."
    }
    $ds = [System.IO.Path]::DirectorySeparatorChar
    $dotbot_bin = "$PSScriptRoot${ds}${dotbot_dir}${ds}bin${ds}dotbot"
    &$python $dotbot_bin -d $PSScriptRoot -c $config_file
    Remove-Variable -Name ds
}

run_dotbot "install.conf.yaml"
if ($IsWindows) {
    run_dotbot "install.win.conf.yaml"
}
