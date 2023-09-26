#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command pip) -and (-not (Get-Variable -Name PWSHRC_FORCE_MODULES_EXPORT_UNSUPPORTED -Scope Global -ValueOnly -ErrorAction SilentlyContinue))) {
    return
}


Get-ChildItem -Path "$PSScriptRoot/*.ps1" | ForEach-Object {
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


Set-Alias -Name pipi -Value "pip install"
Set-Alias -Name pipu -Value "pip install --upgrade"
Set-Alias -Name pipun -Value "pip uninstall"
Set-Alias -Name pipgi -Value "pip freeze | grep"
Set-Alias -Name piplo -Value "pip list -o"

# Create requirements file
function pipreq {
  pip freeze > requirements.txt
}

# Install packages from requirements file
function pipir {
  pip install -r requirements.txt
}

# Upgrade all installed packages
function pipupall {
  [string[]] $packages = (pip list --outdated | Select-Object -Skip 2 | ForEach-Object { $_.Split()[0] })
  if ($packages) {
    pip install --upgrade @packages
  }
}

# Uninstall all installed packages
function pipunall {
  [string[]] $packages = (pip list --format freeze | Select-Object -Skip 2 | ForEach-Object { $_.Split()[0] })
  if ($packages) {
    pip uninstall -y @packages
  }
}

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


Export-ModuleMember -Function * -Alias *
