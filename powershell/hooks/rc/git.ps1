#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command git)) {
    append_profile_suggestions "# TODO: 🐙 Install 'git'. See: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git."
    return
}

# https://www.powershellgallery.com/packages/posh-git
Set-EnvVar -Process -Name POSH_GIT_ENABLED -Value $true
phook_enqueue_module "posh-git"

Remove-Alias -Name gc -Force
Remove-Alias -Name gci -Force
Remove-Alias -Name gcm -Force
Remove-Alias -Name gl -Force
Remove-Alias -Name gm -Force
Remove-Alias -Name gp -Force
phook_enqueue_module "poshy-wrap-git"

if ((Test-Command python3 -ExecutableOnly) -and (Test-Command ruby -ExecutableOnly)) {
    # TODO: Port https://github.com/unixorn/git-extra-commands to PowerShell.
    if (-not $IsWindows) {
        Add-EnvPathItem -Process -Value "$PWD/../../vendor/zsh-custom/plugins/git-extra-commands/bin" -Prepend
    }
}

if (-not (Test-Command git-flow)) {
    append_profile_suggestions "# TODO: 🤷 Install 'git-flow'. See: https://github.com/nvie/gitflow/wiki/Installation."
} else {
    phook_enqueue_module "poshy-wrap-git-flow"
}

# NOTE: We no longer look for Hubflow (`git-hf`) because it was archived in 2023.

if (-not (Test-Command git-lfs)) {
    append_profile_suggestions "# TODO: 🐙 Install 'git-lfs'. See: https://github.com/git-lfs/git-lfs#installing."
} else {
    phook_enqueue_module "poshy-wrap-git-lfs"
}

if (-not (Test-Command git-extras)) {
    append_profile_suggestions "# TODO: 🐙 Install 'git-extras'. See: https://github.com/tj/git-extras/blob/master/Installation.md."
}

if (-not (Test-Command fzf)) {
    append_profile_suggestions "# TODO: 🔎 Install 'fzf'. See: https://github.com/junegunn/fzf#installation."
} elseif (-not (Test-Command forgit)) {
    append_profile_suggestions "# TODO: 🐙 Install 'forgit'. See: https://github.com/wfxr/forgit#-installation."
} else {
    phook_enqueue_module "poshy-wrap-forgit"
}
