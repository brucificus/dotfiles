#
# Module manifest for module 'poshy-notify-send'
#
# Generated by: Pwshrc Maintainers
#
# Generated on: 12/18/2024
#

@{

# Script module or binary module file associated with this manifest.
RootModule = './src/poshy-notify-send.psm1'

# Version number of this module.
ModuleVersion = '0.3.0'

# Supported PSEditions
CompatiblePSEditions = 'Desktop', 'Core'

# ID used to uniquely identify this module
GUID = '71c28581-0183-49e1-af9d-7f6f0531a0d8'

# Author of this module
Author = 'Pwshrc Maintainers'

# Company or vendor of this module
CompanyName = 'Pwshrc Maintainers'

# Copyright statement for this module
Copyright = 'Copyright ©️ 2023 Bruce Markham, All rights reserved.'

# Description of the functionality provided by this module
Description = 'A unified cross-platform wrapper function for generating desktop toast notifications from within your PowerShell session - using whichever toast notification system you have installed.'

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
NestedModules = @('./lib/poshy-lucidity.0.4.1/poshy-lucidity.psd1')

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
        Tags = 'BurntToast', 'GrowlNotify', 'kdialog', 'notifu', 'notify-send', 
               'notify-send-wsl', 'poshy-notify-send', 'PSCommand_notify-send', 
               'PSCommand_notify-send-null', 
               'PSCommand_notify-send-terminalnotifier', 'PSEdition_Core', 
               'PSEdition_Desktop', 'PSFunction_notify-send-null', 
               'PSFunction_notify-send-terminalnotifier', 'PSIncludes_Command', 
               'PSIncludes_Function', 'PSModule', 'pwshrc', 'terminal', 
               'TerminalNotifier', 'toast'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/pwshrc/poshy-notify-send/tree/cac4df19ee4d8ce88b8b4c0800610630d10dcb80/LICENSE.txt'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/pwshrc/poshy-notify-send'

        # A URL to an icon representing this module.
        IconUri = 'https://en.gravatar.com/userimage/238766323/a23519bf4769d01f4e880ce1a538785f.jpeg?size=256'

        # ReleaseNotes of this module
        ReleaseNotes = '## 📦 Other

- :arrow_up: Bump pwshrc/actions-transfer-artifact from 0.3.10 to 0.4.0
- ⬆️ Updates Dependencies & Version Calculation
- 🐛 Fixes Artifact Transfer During Release
- ⬆️Upgrades Codecov Configuration
- ⬆️Upgrades action-gh-release
- ⬆️ Updates Pester from 5.5.0 to 5.6.1
- ⬆️ Updates PSScriptAnalyzer from 1.21.0 to 1.23.0
- ⬆️Upgrades Workflow Dependencies
- ⬆️Upgrades Workflow Dependencies
- ⬇️Downgrades action-gh-release
- ⬆️Updates Dependencies
- 🚨 Fixes Version Calculation for Test Builds
- 🏗️ Splits PSM1, Removes `#Requires` from PSM1
- 🐛 Defines Absent Global Variable'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable


    # PackageVersion
    PackageVersion = '0.3.0'

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

