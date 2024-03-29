#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command -ExecutableOnly ruby) {
    phook_enqueue_module "poshy-wrap-ruby"

} else {
    append_profile_suggestions "# TODO: 💎 Install 'ruby'. See: https://www.ruby-lang.org/en/documentation/installation/."
}

if (Test-Command gem) {
    # Make commands installed with 'gem install --user-install' available
    # ~/.gem/ruby/${RUBY_VERSION}/bin/
    [string] $gemUserDir = (ruby -e 'print Gem.user_dir')
    Add-EnvPathItem -Process -Value "${gemUserDir}/bin"

    phook_enqueue_module "poshy-wrap-gem"
}
