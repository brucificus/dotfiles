#
# Module manifest for module 'poshy-wrap-docker-compose'
#
# Generated by: Pwshrc Maintainers
#
# Generated on: 12/31/2023
#

@{

# Script module or binary module file associated with this manifest.
RootModule = './src/poshy-wrap-docker-compose.psm1'

# Version number of this module.
ModuleVersion = '0.2.14'

# Supported PSEditions
CompatiblePSEditions = 'Desktop', 'Core'

# ID used to uniquely identify this module
GUID = 'b49ea956-c892-4fd5-87d8-48928f4da7ae'

# Author of this module
Author = 'Pwshrc Maintainers'

# Company or vendor of this module
CompanyName = 'Pwshrc Maintainers'

# Copyright statement for this module
Copyright = 'Copyright ©️ 2023 Bruce Markham, All rights reserved.'

# Description of the functionality provided by this module
Description = 'Convenient cmdlets and aliases which wrap `docker-compose`.'

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
        Tags = 'docker-compose', 'poshy-wrap', 'poshy-wrap-docker-compose', 
               'PSCommand_dcb', 'PSCommand_dcdn', 'PSCommand_dce', 'PSCommand_dck', 
               'PSCommand_dcl', 'PSCommand_dclf', 'PSCommand_dco', 
               'PSCommand_dcofresh', 'PSCommand_dcol', 'PSCommand_dcou', 
               'PSCommand_dcouns', 'PSCommand_dcps', 'PSCommand_dcpull', 
               'PSCommand_dcr', 'PSCommand_dcrestart', 'PSCommand_dcrm', 
               'PSCommand_dcstart', 'PSCommand_dcstop', 'PSCommand_dcup', 
               'PSCommand_dcupb', 'PSCommand_dcupbd', 'PSCommand_dcupd', 
               'PSCommand_docker-compose-fresh', 
               'PSCommand_Invoke-DockerComposeBuild', 
               'PSCommand_Invoke-DockerComposeDown', 
               'PSCommand_Invoke-DockerComposeExec', 
               'PSCommand_Invoke-DockerComposeKill', 
               'PSCommand_Invoke-DockerComposeLogs', 
               'PSCommand_Invoke-DockerComposeLogsFollow', 
               'PSCommand_Invoke-DockerComposeLogsFollowTail', 
               'PSCommand_Invoke-DockerComposePs', 
               'PSCommand_Invoke-DockerComposePull', 
               'PSCommand_Invoke-DockerComposeRestart', 
               'PSCommand_Invoke-DockerComposeRm', 
               'PSCommand_Invoke-DockerComposeRun', 
               'PSCommand_Invoke-DockerComposeStart', 
               'PSCommand_Invoke-DockerComposeStop', 
               'PSCommand_Invoke-DockerComposeUp', 
               'PSCommand_Invoke-DockerComposeUpDetached', 
               'PSCommand_Invoke-DockerComposeUpDetachedWithBuild', 
               'PSCommand_Invoke-DockerComposeUpNoStart', 
               'PSCommand_Invoke-DockerComposeUpWithBuild', 'PSEdition_Core', 
               'PSEdition_Desktop', 'PSFunction_docker-compose-fresh', 
               'PSFunction_Invoke-DockerComposeBuild', 
               'PSFunction_Invoke-DockerComposeDown', 
               'PSFunction_Invoke-DockerComposeExec', 
               'PSFunction_Invoke-DockerComposeKill', 
               'PSFunction_Invoke-DockerComposeLogs', 
               'PSFunction_Invoke-DockerComposeLogsFollow', 
               'PSFunction_Invoke-DockerComposeLogsFollowTail', 
               'PSFunction_Invoke-DockerComposePs', 
               'PSFunction_Invoke-DockerComposePull', 
               'PSFunction_Invoke-DockerComposeRestart', 
               'PSFunction_Invoke-DockerComposeRm', 
               'PSFunction_Invoke-DockerComposeRun', 
               'PSFunction_Invoke-DockerComposeStart', 
               'PSFunction_Invoke-DockerComposeStop', 
               'PSFunction_Invoke-DockerComposeUp', 
               'PSFunction_Invoke-DockerComposeUpDetached', 
               'PSFunction_Invoke-DockerComposeUpDetachedWithBuild', 
               'PSFunction_Invoke-DockerComposeUpNoStart', 
               'PSFunction_Invoke-DockerComposeUpWithBuild', 'PSIncludes_Command', 
               'PSIncludes_Function', 'PSModule', 'pwshrc'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/pwshrc/poshy-wrap-docker-compose/tree/c246487bf2d60b085ea75353874c12afcbb96dbb/LICENSE.txt'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/pwshrc/poshy-wrap-docker-compose'

        # A URL to an icon representing this module.
        IconUri = 'https://en.gravatar.com/userimage/238766323/a23519bf4769d01f4e880ce1a538785f.jpeg?size=256'

        # ReleaseNotes of this module
        ReleaseNotes = '## 📦 Uncategorized

- :arrow_up: Bump pwshrc/actions-review-dependabot from 0.6.2 to 0.6.3
   - PR: #0
- :arrow_up: Bump pwshrc/actions-determine-version from 0.8.6 to 0.8.7
   - PR: #0
- :arrow_up: Bump pwshrc/actions-invoke-lib-dependent-pwsh
   - PR: #0
- :arrow_up: Bump pwshrc/actions-transfer-artifact from 0.3.9 to 0.3.10
   - PR: #0
- :arrow_up: Bump pwshrc/actions-create-release-notes from 0.8.8 to 0.8.10
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

