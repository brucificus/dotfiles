#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

phook_push_module "poshy-dir-nav"

function here() {
    if (( $args.Length -eq 1 )) {
        [string] $loc = (realpath $1)
    }
    else {
        [string] $loc = (realpath ".")
    }
    ln -sfn $loc "$HOME/.shell.here"
    Write-Output "here -> $(readlink "$HOME/.shell.here")"
}

Set-EnvVar -Process -Name there -Value "$HOME/.shell.here"

function there() {
    Set-Location (readlink $Env:there)
}

Set-PSReadLineKeyHandler -Chord Alt+UpArrow -ScriptBlock { Set-LocationUp1 }
Set-PSReadLineKeyHandler -Chord Alt+DownArrow -ScriptBlock { Set-LocationDown1 }
Set-PSReadLineKeyHandler -Chord Alt+LeftArrow -ScriptBlock { Set-LocationBack1 }
Set-PSReadLineKeyHandler -Chord Alt+RightArrow -ScriptBlock { Set-LocationForward1 }

if (Test-Command zoxide) {
    # We don't use a special "plugin" for Zoxide, because eval'ing it is enough.
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
else {
    append_profile_suggestions "# TODO: ⚡ Install 'zoxide'. See: https://github.com/ajeetdsouza/zoxide#installation."
}
