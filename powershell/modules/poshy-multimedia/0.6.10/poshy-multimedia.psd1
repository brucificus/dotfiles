#
# Module manifest for module 'poshy-multimedia'
#
# Generated by: Pwshrc Maintainers
#
# Generated on: 09/25/2023
#

@{

# Script module or binary module file associated with this manifest.
RootModule = './src/poshy-multimedia.psm1'

# Version number of this module.
ModuleVersion = '0.6.10.0'

# Supported PSEditions
CompatiblePSEditions = 'Desktop', 'Core'

# ID used to uniquely identify this module
GUID = 'faacff00-69d9-4c4f-8e74-0d3352100a37'

# Author of this module
Author = 'Pwshrc Maintainers'

# Company or vendor of this module
CompanyName = 'Pwshrc Maintainers'

# Copyright statement for this module
Copyright = 'Copyright ©️ 2023 Bruce Markham, All rights reserved.'

# Description of the functionality provided by this module
Description = 'Convenient cmdlets for working with various archive, multimedia, and data-encoding formats directly in your PowerShell terminal.'

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
NestedModules = @('./lib/poshy-colors.0.3.1/poshy-colors.psd1', 
               './lib/poshy-ecks.0.5.1/poshy-ecks.psd1', 
               './lib/poshy-lucidity.0.3.2/poshy-lucidity.psd1')

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
        Tags = 'catimage', 'decode64', 'encode64', 'iso', 'poshy-multimedia', 
               'PSCommand_catimg', 'PSCommand_d64', 'PSCommand_decode64', 
               'PSCommand_decodefile64', 'PSCommand_df64', 'PSCommand_e64', 
               'PSCommand_ef64', 'PSCommand_encode64', 'PSCommand_encodefile64', 
               'PSCommand_extract', 'PSCommand_New-IsoFile', 
               'PSCommand_open_command', 'PSCommand_peek', 
               'PSCommand_universalarchive', 'PSCommand_urldecode', 
               'PSCommand_urlencode', 'PSCommand_uuid', 'PSCommand_uuidgen', 
               'PSCommand_uuidl', 'PSCommand_uuidu', 'PSEdition_Core', 
               'PSEdition_Desktop', 'PSFunction_catimg', 'PSFunction_decode64', 
               'PSFunction_decodefile64', 'PSFunction_encode64', 
               'PSFunction_encodefile64', 'PSFunction_extract', 
               'PSFunction_New-IsoFile', 'PSFunction_open_command', 
               'PSFunction_peek', 'PSFunction_universalarchive', 
               'PSFunction_urldecode', 'PSFunction_urlencode', 'PSFunction_uuidl', 
               'PSFunction_uuidu', 'PSIncludes_Command', 'PSIncludes_Function', 
               'PSModule', 'pwshrc', 'universalarchive', 'urldecode', 'urlencode'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/pwshrc/poshy-multimedia/tree/c9fa00de623139b6ea64f7b44665099cc2881b56/LICENSE.txt'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/pwshrc/poshy-multimedia'

        # A URL to an icon representing this module.
        IconUri = 'https://en.gravatar.com/userimage/238766323/a23519bf4769d01f4e880ce1a538785f.jpeg?size=256'

        # ReleaseNotes of this module
        ReleaseNotes = '## 📦 Uncategorized

- :arrow_up: Bump pwshrc/actions-review-dependabot from 0.6.0 to 0.6.1
   - PR: #0
- :arrow_up: Bump pwshrc/actions-invoke-lib-dependent-pwsh
   - PR: #0
- 👷 Updates Build Scripts
   - PR: #0
- 👷 Updates Validation Workflow
   - PR: #0
- 👷 Updates Publish Workflow
   - PR: #0
- 👷 Updates Dependabot PR Review Workflow
   - PR: #0'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable


    # PackageVersion
    PackageVersion = '0.6.10'

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

