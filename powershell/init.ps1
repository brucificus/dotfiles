#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$InformationPreference = "Continue"

Import-Module -Name "$PSScriptRoot/internal-modules/poshy-phookq/" -DisableNameChecking
phook_enqueue_folder "$PSScriptRoot/modules/poshy-env-var/" -AsFunctions
phook_enqueue_folder "$PSScriptRoot/internal-modules/poshy-misc-funcs/" -AsFunctions

./_phook_enqueue_local_before.ps1
phook_enqueue_folder "$PSScriptRoot/hooks/${Global:phook_mode}/" -Optional
phook_enqueue_folder "$HOME/.config/powershell/hooks_local/${Global:phook_mode}/" -Optional
./_phook_enqueue_local_after.ps1

. ./_phook_loader_execute.ps1

$InformationPreference = "SilentlyContinue"
