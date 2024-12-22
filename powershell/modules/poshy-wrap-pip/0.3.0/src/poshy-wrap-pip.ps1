#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


Get-ChildItem -Path "$PSScriptRoot/*.ps1" | Where-Object { $_.BaseName.StartsWith("_") } | ForEach-Object {
    . $_.FullName
}

Set-Alias -Name pip3 -Value _pip3
Set-Alias -Name syspip3 -Value _syspip3
Set-Alias -Name pip -Value _pip3
Set-Alias -Name syspip -Value _pip3

Set-Alias -Name pip3_package_location -Value _pip3_package_location
Set-Alias -Name pip_package_location -Value _pip3_package_location
Set-Alias -Name syspip3_package_location -Value _syspip3_package_location
Set-Alias -Name syspip_package_location -Value _syspip3_package_location

Export-ModuleMember -Alias @(
  "pip3",
  "syspip3",
  "pip",
  "syspip",
  "pip3_package_location",
  "pip_package_location",
  "syspip3_package_location",
  "syspip_package_location"
)

function Invoke-PipInstall {
  pip install @args
}
Set-Alias -Name pipi -Value Invoke-PipInstall
Export-ModuleMember -Function Invoke-PipInstall -Alias pipi

function Invoke-PipInstallUpgrade {
  pip install --upgrade @args
}
Set-Alias -Name pipu -Value Invoke-PipInstallUpgrade
Export-ModuleMember -Function Invoke-PipInstallUpgrade -Alias pipu

function Invoke-PipUninstall {
  pip uninstall @args
}
Set-Alias -Name pipun -Value Invoke-PipUninstall
Export-ModuleMember -Function Invoke-PipUninstall -Alias pipun

function Invoke-GrepPipFreeze {
  pip freeze | grep @args
}
Set-Alias -Name pipgi -Value Invoke-GrepPipFreeze
Export-ModuleMember -Function Invoke-GrepPipFreeze -Alias pipgi

function Invoke-PipListOutdated {
  pip list -o @args
}
Set-Alias -Name piplo -Value Invoke-PipListOutdated
Export-ModuleMember -Function Invoke-PipListOutdated -Alias piplo

# Create requirements file
function pipreq {
  pip freeze > requirements.txt
}
Export-ModuleMember -Function pipreq

# Install packages from requirements file
function pipir {
  pip install -r requirements.txt
}
Export-ModuleMember -Function pipir

# Upgrade all installed packages
function pipupall {
  [string[]] $packages = (pip list --outdated | Select-Object -Skip 2 | ForEach-Object { $_.Split()[0] })
  if ($packages) {
    pip install --upgrade @packages
  }
}
Export-ModuleMember -Function pipupall

# Uninstall all installed packages
function pipunall {
  [string[]] $packages = (pip list --format freeze | Select-Object -Skip 2 | ForEach-Object { $_.Split()[0] })
  if ($packages) {
    pip uninstall -y @packages
  }
}
Export-ModuleMember -Function pipunall

# Install from GitHub repository
function pipig {
  param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidationScript({ $_ -match '^[^/]+/[^/]+$' })] # GitHub repository name
    [string] $ownerAndRepo
  )
  pip install "git+https://github.com/${ownerAndRepo}.git"
}
Export-ModuleMember -Function pipig

# Install from GitHub branch
function pipigb {
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidationScript({ $_ -match '^[^/]+/[^/]+$' })] # GitHub repository name
    [string] $ownerAndRepo,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $branchish
 )
  pip install "git+https://github.com/${ownerAndRepo}.git@${branchish}"
}
Export-ModuleMember -Function pipigb

# Install from GitHub pull request
function pipigp {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidationScript({ $_ -match '^[^/]+/[^/]+$' })] # GitHub repository name
        [string] $ownerAndRepo,

        [Parameter(Mandatory=$true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $pullRequestNumber
     )
  pip install "git+https://github.com/${ownerAndRepo}.git@refs/pull/${pullRequestNumber}/head"
}
Export-ModuleMember -Function pipigp
