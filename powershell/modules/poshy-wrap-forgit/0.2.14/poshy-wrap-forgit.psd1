#
# Module manifest for module 'poshy-wrap-forgit'
#
# Generated by: Pwshrc Maintainers
#
# Generated on: 12/31/2023
#

@{

# Script module or binary module file associated with this manifest.
RootModule = './src/poshy-wrap-forgit.psm1'

# Version number of this module.
ModuleVersion = '0.2.14'

# Supported PSEditions
CompatiblePSEditions = 'Desktop', 'Core'

# ID used to uniquely identify this module
GUID = 'e537a81c-3f6c-4a90-be8a-fa35544e572f'

# Author of this module
Author = 'Pwshrc Maintainers'

# Company or vendor of this module
CompanyName = 'Pwshrc Maintainers'

# Copyright statement for this module
Copyright = 'Copyright ©️ 2023 Bruce Markham, All rights reserved.'

# Description of the functionality provided by this module
Description = 'Convenient cmdlets and aliases which wrap `forgit`.'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '7.0'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @('./lib/poshy-lucidity.0.3.16/poshy-lucidity.psd1')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = '*'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = '*'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'forgit', 'poshy-wrap', 'poshy-wrap-forgit', 'PSCommand_forgit-add', 
               'PSCommand_forgit-blame', 'PSCommand_forgit-branch-delete', 
               'PSCommand_forgit-checkout-branch', 
               'PSCommand_forgit-checkout-commit', 
               'PSCommand_forgit-checkout-file', 'PSCommand_forgit-checkout-tag', 
               'PSCommand_forgit-cherry-pick', 
               'PSCommand_forgit-cherry-pick-from-branch', 
               'PSCommand_forgit-clean', 'PSCommand_forgit-diff', 
               'PSCommand_forgit-fixup', 'PSCommand_forgit-ignore', 
               'PSCommand_forgit-ignore-clean', 'PSCommand_forgit-ignore-list', 
               'PSCommand_forgit-ignore-update', 'PSCommand_forgit-ignoreget', 
               'PSCommand_forgit-log', 'PSCommand_forgit-rebase', 
               'PSCommand_forgit-reset-head', 'PSCommand_forgit-revert-commit', 
               'PSCommand_forgit-stash-push', 'PSCommand_forgit-stash-show', 
               'PSCommand_ga', 'PSCommand_gbd', 'PSCommand_gbl', 'PSCommand_gcb', 
               'PSCommand_gcf', 'PSCommand_gclean', 'PSCommand_gco', 'PSCommand_gcp', 
               'PSCommand_gct', 'PSCommand_gd', 'PSCommand_gfu', 'PSCommand_gi', 
               'PSCommand_glo', 'PSCommand_grb', 'PSCommand_grc', 'PSCommand_grh', 
               'PSCommand_gsp', 'PSCommand_gss', 'PSEdition_Core', 'PSEdition_Desktop', 
               'PSFunction_forgit-add', 'PSFunction_forgit-blame', 
               'PSFunction_forgit-branch-delete', 
               'PSFunction_forgit-checkout-branch', 
               'PSFunction_forgit-checkout-commit', 
               'PSFunction_forgit-checkout-file', 'PSFunction_forgit-checkout-tag', 
               'PSFunction_forgit-cherry-pick', 
               'PSFunction_forgit-cherry-pick-from-branch', 
               'PSFunction_forgit-clean', 'PSFunction_forgit-diff', 
               'PSFunction_forgit-fixup', 'PSFunction_forgit-ignore', 
               'PSFunction_forgit-ignore-clean', 'PSFunction_forgit-ignore-list', 
               'PSFunction_forgit-ignore-update', 'PSFunction_forgit-ignoreget', 
               'PSFunction_forgit-log', 'PSFunction_forgit-rebase', 
               'PSFunction_forgit-reset-head', 'PSFunction_forgit-revert-commit', 
               'PSFunction_forgit-stash-push', 'PSFunction_forgit-stash-show', 
               'PSIncludes_Command', 'PSIncludes_Function', 'PSModule', 'pwshrc'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/pwshrc/poshy-wrap-forgit/tree/9fd90984ca254c1d842973608af0e7c6c4a8180e/LICENSE.txt'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/pwshrc/poshy-wrap-forgit'

        # A URL to an icon representing this module.
        IconUri = 'https://en.gravatar.com/userimage/238766323/a23519bf4769d01f4e880ce1a538785f.jpeg?size=256'

        # ReleaseNotes of this module
        ReleaseNotes = '## 📦 Uncategorized

- :arrow_up: Bump pwshrc/actions-invoke-lib-dependent-pwsh
   - PR: #0
- :arrow_up: Bump pwshrc/actions-create-release-notes from 0.8.8 to 0.8.10
   - PR: #0
- :arrow_up: Bump pwshrc/actions-review-dependabot from 0.6.2 to 0.6.3
   - PR: #0
- :arrow_up: Bump pwshrc/actions-transfer-artifact from 0.3.9 to 0.3.10
   - PR: #0
- :arrow_up: Bump pwshrc/actions-determine-version from 0.8.6 to 0.8.7
   - PR: #0
- :arrow_up: Bump pwshrc/actions-create-release-notes
   - PR: #0
- ⬆️ Updates poshy-lucidity from 0.3.2 to 0.3.16
   - PR: #0'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable


    # PackageVersion
    PackageVersion = '0.2.14'

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
