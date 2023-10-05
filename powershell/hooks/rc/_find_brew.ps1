#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Credit:
#   - Oh-My-Zsh's brew.plugin.zsh, see: https://github.com/ohmyzsh/ohmyzsh/blob/f4dc8c5be365668810783ced01a86ff8f251bfd7/plugins/brew/brew.plugin.zsh


# Configure brew, first finding it if necessary.

if (-not (Test-Command brew)) {
    [string] $ds = [System.IO.Path]::DirectorySeparatorChar
    [string[]] $brewPaths = @(
        "${HOME}${ds}.linuxbrew${ds}bin${ds}brew",
        "${HOME}${ds}..${ds}linuxbrew${ds}.linuxbrew${ds}bin${ds}brew",
        "/home/linuxbrew/.linuxbrew/bin/brew", # Redundant with the above. Usually.
        "/opt/homebrew/bin/brew",
        "/usr/local/bin/brew"
    )
    foreach ($brewPath in $brewPaths) {
        if (Test-Path -Path $brewPath) {
            Write-Debug "Found brew at '$brewPath'."
            Add-EnvPathItem -Process $brewPath
            break
        }
    }
}

[string] $brew_bin = Search-CommandPath brew
if (-not $brew_bin) {
    if (-not $IsWindows) {
        append_profile_suggestions "# TODO: 🍺 Install 'brew'. See: https://docs.brew.sh/Homebrew-on-Linux"
    }
    return
}
[string[]] $brewInitResult = (&$brew_bin shellenv)
$brewInitResult | Invoke-Expression

phook_enqueue_module "poshy-wrap-brew"
