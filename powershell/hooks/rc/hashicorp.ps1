#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command packer) {

} elseif ((Test-Command aws -ExecutableOnly) -or (Test-Command az -ExecutableOnly) -or (Test-Command vagrant) -or (Test-Command docker) -or (Test-Command vboxmanage)) {
    append_profile_suggestions "# TODO: 📦 Install 'packer'. See: https://developer.hashicorp.com/packer/downloads."
}

if (Test-Command terraform) {
    phook_enqueue_module "poshy-wrap-terraform"
} elseif ((Test-Command az -ExecutableOnly) -or (Test-Command aws -ExecutableOnly)) {
    append_profile_suggestions "# TODO: ☄️ Install 'terraform'. See: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli."
}

if (Test-Command terragrunt) {
    phook_enqueue_module "poshy-wrap-terragrunt"
} elseif ((Test-Command terraform)) {
    append_profile_suggestions "# TODO: 🪖 Install 'terragrunt'. See: https://terragrunt.gruntwork.io/docs/getting-started/install/."
}

if (Test-Command vagrant) {
    phook_enqueue_module "poshy-wrap-vagrant"
} elseif ((Test-Command packer) -or (Test-Command vboxmanage)) {
    append_profile_suggestions "# TODO: ⛺ Install 'vagrant'. See: https://developer.hashicorp.com/vagrant/downloads."
}

if (Test-Command vault) {
    phook_enqueue_module "poshy-wrap-vault"
}
