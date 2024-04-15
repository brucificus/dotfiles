#
# Module manifest for module 'poshy-env-var'
#
# Generated by: Pwshrc Maintainers
#
# Generated on: 08/26/2023
#

@{

# Script module or binary module file associated with this manifest.
RootModule = './src/poshy-env-var.psm1'

# Version number of this module.
ModuleVersion = '0.5.0.0'

# Supported PSEditions
CompatiblePSEditions = 'Desktop', 'Core'

# ID used to uniquely identify this module
GUID = '9726e675-d7fc-49c4-95ee-25f96e4741d4'

# Author of this module
Author = 'Pwshrc Maintainers'

# Company or vendor of this module
CompanyName = 'Pwshrc Maintainers'

# Copyright statement for this module
Copyright = 'Copyright ©️ 2023 Bruce Markham, All rights reserved.'

# Description of the functionality provided by this module
Description = 'Ergonomic cmdlets for assigning, retrieving, and deleting environment variables - including path-munging for arbitrary PATH variables.'

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
NestedModules = @('./lib/poshy-lucidity.0.3.2/poshy-lucidity.psd1')

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
        Tags = 'dotenv', 'Environment', 'EnvironmentVariable', 'Path', 'poshy-env-var', 
               'PSCommand_Add-EnvPathItem', 'PSCommand_Add-EnvVarPathItem', 
               'PSCommand_Get-EnvPathItem', 'PSCommand_Get-EnvVar', 
               'PSCommand_Get-EnvVarPathItem', 'PSCommand_Measure-EnvVarChanges', 
               'PSCommand_Read-DotEnv', 'PSCommand_Remove-EnvPathItem', 
               'PSCommand_Remove-EnvVar', 'PSCommand_Remove-EnvVarPathItem', 
               'PSCommand_Set-EnvVar', 'PSEdition_Core', 'PSEdition_Desktop', 
               'PSFunction_Add-EnvPathItem', 'PSFunction_Add-EnvVarPathItem', 
               'PSFunction_Get-EnvPathItem', 'PSFunction_Get-EnvVar', 
               'PSFunction_Get-EnvVarPathItem', 'PSFunction_Measure-EnvVarChanges', 
               'PSFunction_Read-DotEnv', 'PSFunction_Remove-EnvPathItem', 
               'PSFunction_Remove-EnvVar', 'PSFunction_Remove-EnvVarPathItem', 
               'PSFunction_Set-EnvVar', 'PSIncludes_Command', 'PSIncludes_Function', 
               'PSModule', 'pwshrc'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/pwshrc/poshy-env-var/tree/ead385c6207e354cb94e34837b4fd276e3c0f70b/LICENSE.txt'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/pwshrc/poshy-env-var'

        # A URL to an icon representing this module.
        IconUri = 'https://en.gravatar.com/userimage/238766323/a23519bf4769d01f4e880ce1a538785f.jpeg?size=256'

        # ReleaseNotes of this module
        ReleaseNotes = '## 📦 Uncategorized

- ➕ Updates PSGallery NuGet Configuration
   - PR: #0
- 👷 Updates Build Scripts
   - PR: #0
- 👷 Updates Build Scripts
   - PR: #0
- 👷 Updates Build Scripts
   - PR: #0
- ➕ Updates PSGallery NuGet Configuration
   - PR: #0'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable


    # PackageVersion
    PackageVersion = '0.5.0'

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
