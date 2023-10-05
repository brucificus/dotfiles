#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

if (Test-Command az -ExecutableOnly) {
    # Intentionally left blank.
} elseif ((Test-Command terraform) -or (Test-Command packer)) {
    append_profile_suggestions "# TODO: ☁️ Install the Azure CLI. See: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli."
}

if (Get-Module Az -ListAvailable -ErrorAction SilentlyContinue) {
    if (Get-Module AzureRM -ListAvailable -ErrorAction SilentlyContinue) {
        append_profile_suggestions "# TODO: ⛔ Remove the legacy AzureRM PowerShell module - it conflicts with the newer module and is deprecated regardless. See: https://learn.microsoft.com/en-us/powershell/azure/migrate-from-azurerm-to-az."
        return
    }

    Set-EnvVar -Process -Name POSH_AZURE_ENABLED -Value $true

    # NOTE: We purposefully *don't* `phook_enqueue_module "Az"`.
    #       Loading module "Az" takes on the order of 1.5+ minutes, because it also loads _dozens_ of submodules.
    #       Instead, we'll load the module on-demand, when the user actually needs it.

} elseif (Test-Command az -ExecutableOnly) {
    append_profile_suggestions "# TODO: ☁️ Install the Az PowerShell module. See: https://github.com/Azure/azure-powershell#installation."
}
