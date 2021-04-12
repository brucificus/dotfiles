#!/usr/bin/env pwsh

[CmdletBinding()]
param (
    [string] $path
)

function ResolvePathWithPossibleExtension([string] $path, [string] $extension)
{
    [string] $pathWithExtensionAppended = $path + $extension

    if (Test-Path $pathWithExtensionAppended -ErrorAction SilentlyContinue) {
        return (Resolve-Path -Path $pathWithExtensionAppended -Relative)
    } else {
        return $pathWithExtensionAppended
    }
}

[string] $pathAsScriptModule = ResolvePathWithPossibleExtension -path $path -extension ".psm1"
[string] $pathAsAssemblyModule = ResolvePathWithPossibleExtension -path $path -extension ".dll"
[string] $pathAsScript = ResolvePathWithPossibleExtension -path $path -extension ".ps1"
[string] $pathWithoutExtension = ResolvePathWithPossibleExtension -path $path -extension ""

if (Test-Path $pathAsScriptModule -ErrorAction SilentlyContinue) {
    Import-Module -Name (Resolve-Path $pathAsScriptModule) -DisableNameChecking
} elseif (Test-Path $pathAsAssemblyModule -ErrorAction SilentlyContinue) {
    Import-Module -Assembly (Resolve-Path $pathAsAssemblyModule) -DisableNameChecking
} elseif (Test-Path $pathAsScript -ErrorAction SilentlyContinue) {
    . "$pathAsScript"
} elseif (Test-Path $pathWithoutExtension -ErrorAction SilentlyContinue) {
    . "$pathWithoutExtension"
}
