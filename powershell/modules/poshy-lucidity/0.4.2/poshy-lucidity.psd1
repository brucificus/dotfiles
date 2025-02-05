#
# Module manifest for module 'poshy-lucidity'
#
# Generated by: Pwshrc Maintainers
#
# Generated on: 12/18/2024
#

@{

# Script module or binary module file associated with this manifest.
RootModule = './src/poshy-lucidity.psm1'

# Version number of this module.
ModuleVersion = '0.4.2'

# Supported PSEditions
CompatiblePSEditions = 'Desktop', 'Core'

# ID used to uniquely identify this module
GUID = '4fc88106-f088-4fee-800e-a924b42dc8b3'

# Author of this module
Author = 'Pwshrc Maintainers'

# Company or vendor of this module
CompanyName = 'Pwshrc Maintainers'

# Copyright statement for this module
Copyright = 'Copyright ©️ 2023 Bruce Markham, All rights reserved.'

# Description of the functionality provided by this module
Description = 'Convenient general-purpose cmdlets to help you write your PowerShell scripts - the "batteries" that should have been included in the original packaging.'

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
NestedModules = @()

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
        Tags = 'elevation', 'link-capability', 'poshy-lucidity', 
               'PSCommand_Search-CommandPath', 'PSCommand_Test-Command', 
               'PSCommand_Test-Elevation', 'PSCommand_Test-LinkCapability', 
               'PSCommand_Test-ReparsePoint', 
               'PSCommand_Test-SessionInteractivity', 'PSEdition_Core', 
               'PSEdition_Desktop', 'PSFunction_Search-CommandPath', 
               'PSFunction_Test-Command', 'PSFunction_Test-Elevation', 
               'PSFunction_Test-LinkCapability', 'PSFunction_Test-ReparsePoint', 
               'PSFunction_Test-SessionInteractivity', 'PSIncludes_Command', 
               'PSIncludes_Function', 'PSModule', 'pwshrc', 'sudo', 'symlink', 'UAC'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/pwshrc/poshy-lucidity/tree/afa29e88b1ff17a4c1ecc0dd6ac1b9c9b9799b42/LICENSE.txt'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/pwshrc/poshy-lucidity'

        # A URL to an icon representing this module.
        IconUri = 'https://en.gravatar.com/userimage/238766323/a23519bf4769d01f4e880ce1a538785f.jpeg?size=256'

        # ReleaseNotes of this module
        ReleaseNotes = '## 📦 Other

- :arrow_up: Bump softprops/action-gh-release from 2.1.0 to 2.2.0
- 🚨 Fixes Version Calculation for Test Builds'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable


    # PackageVersion
    PackageVersion = '0.4.2'

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

