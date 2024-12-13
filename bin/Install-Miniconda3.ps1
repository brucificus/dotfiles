#!/usr/bin/env pwsh

<#PSScriptInfo

.VERSION 0.0.1

.GUID 20b978d6-4910-4505-9e7d-6148f29850de

.AUTHOR Bruce Markham

.COPYRIGHT © 2024 Bruce Markham.

.TAGS miniconda conda Python powershell powershell-script Windows MacOS Linux PSEdition_Core PSEdition_Desktop

.LICENSEURI https://github.com/…/…/blob/main/LICENSE.txt

.PROJECTURI https://github.com/…/…

.ICONURI https://raw.githubusercontent.com/…/…/main/images/…-logo.png

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

#>

<#
.SYNOPSIS
    Installs Miniconda 3 on Windows, macOS, or Linux.

    TODO:
    You may also run this script directly from the web using the following command:

    ```powershell
    & ([scriptblock]::Create((iwr 'https://…/Install-Miniconda3.ps1')))
    ```

    Parameters may be passed at the end just like any other PowerShell script.

.DESCRIPTION
    Installer for Miniconda on Windows, macOS, or Linux.

    TODO:
    Besides installing the script locally, you may also run this script directly from the web
    using the following command:

    ```powershell
    & ([scriptblock]::Create((iwr 'https://…/Install-Miniconda3.ps1')))
    ```

    Or alternatively without the shortened URL:

    ```powershell
    & ([scriptblock]::Create((iwr 'https://raw.githubusercontent.com/…/…/main/Install-Miniconda3.ps1')))
    ```

    > **IMPORTANT**: A code signature cannot be verified when running the script directly from the web.
    > SSL transport layer encryption is used to protect the script during download from GitHub and during
    > redirection from the URL shortener.

    Parameters may be passed just like any other PowerShell script. For example:

    ```powershell
    & ([scriptblock]::Create((iwr 'https://to.loredo.me/Install-Miniconda3.ps1'))) -Scope AllUsers
    ```
#>

[CmdletBinding(ConfirmImpact = 'High')]
param(
)

dynamicparam {
    Set-StrictMode -Off
    $script:InstallerArgs = [string[]]@()

    $runtimeParameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

    # add `Scope` parameter
    $parameterName = 'Scope'
    $validateSetAttribute = $IsWindows ? `
        [System.Management.Automation.ValidateSetAttribute]::new('AllUsers', 'CurrentUser') `
        : [System.Management.Automation.ValidateSetAttribute]::new([string[]]@('CurrentUser'))
    $parameterAttributes = [System.Collections.ObjectModel.Collection[System.Attribute]]@(
        [System.Management.Automation.ParameterAttribute]@{
            ParameterSetName = '__AllParameterSets'
            Position = 0
            Mandatory = $false
            HelpMessage = 'The scope in which Miniconda 3 should be installed.'
        },
        $validateSetAttribute
    )
    $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new($parameterName, [string], $parameterAttributes)
    if (-not $PSBoundParameters.ContainsKey('Scope')) {
        $parameter.Value = 'CurrentUser'
    }
    $runtimeParameterDictionary.Add($parameterName, $parameter)

    # add `AddToPath` switch
    if ($IsWindows) {
        $parameterName = 'AddToPath'
        $validateScriptAttribute = [System.Management.Automation.ValidateScriptAttribute]::new({
            # Validate that the switch wasn't provided when the scope is AllUsers.
            if ($PSBoundParameters.Scope -ne 'CurrentUser' -and $PSBoundParameters.AddToPath) {
                throw 'AddToPath is *only* supported when the scope is CurrentUser; the underlying installer ignores it otherwise.'
            }
        })
        $parameterAttributes = [System.Collections.ObjectModel.Collection[System.Attribute]]@(
            [System.Management.Automation.ParameterAttribute]@{
                ParameterSetName = '__AllParameterSets'
                Position = 1
                Mandatory = $false
                HelpMessage = 'Add the Miniconda 3 installation directory to the PATH environment variable. *Only* supported when the scope is CurrentUser; the underlying installer ignores it otherwise.'
            },
            $validateScriptAttribute
        )
        $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new($parameterName, [switch], $parameterAttributes)
        $runtimeParameterDictionary.Add($parameterName, $parameter)
    }

    # add `RegisterPython` switch
    if ($IsWindows) {
        $parameterName = 'RegisterPython'
        $parameterAttributes = [System.Collections.ObjectModel.Collection[System.Attribute]]@(
            [System.Management.Automation.ParameterAttribute]@{
                ParameterSetName = '__AllParameterSets'
                Position = 2
                Mandatory = $false
                HelpMessage = 'Register the Miniconda 3 Python installation as a system Python. Default is false when the scope is CurrentUser, true when the scope is AllUsers.'
            }
        )
        $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new($parameterName, [switch], $parameterAttributes)
        if ($PSBoundParameters.Scope -eq 'AllUsers' -and (-not $PSBoundParameters.ContainsKey('RegisterPython'))) {
            $parameter.Value = $true
        } else {
            $parameter.Value = $false
        }
        $runtimeParameterDictionary.Add($parameterName, $parameter)
    }

    # add `NoRegistry` switch
    if ($IsWindows) {
        $parameterName = 'NoRegistry'
        $parameterAttributes = [System.Collections.ObjectModel.Collection[System.Attribute]]@(
            [System.Management.Automation.ParameterAttribute]@{
                ParameterSetName = '__AllParameterSets'
                Position = 3
                Mandatory = $false
                HelpMessage = 'Do not add Miniconda 3 to the Windows registry - useful for CI environments. Default is false.'
            }
        )
        $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new($parameterName, [switch], $parameterAttributes)
        $runtimeParameterDictionary.Add($parameterName, $parameter)
    }

    # add `Prefix` parameter
    if (-not $IsWindows) {
        $parameterName = 'Prefix'
        $parameterAttributes = [System.Collections.ObjectModel.Collection[System.Attribute]]@(
            [System.Management.Automation.ParameterAttribute]@{
                ParameterSetName = '__AllParameterSets'
                Position = 4
                Mandatory = $false
                HelpMessage = 'The directory to which Miniconda 3 should be installed. Default is $HOME/miniconda3.'
            }
        )
        $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new($parameterName, [string], $parameterAttributes)
        if (-not $PSBoundParameters.ContainsKey('Prefix')) {
            $parameter.Value = "$Env:HOME/miniconda3"
        }
        $runtimeParameterDictionary.Add($parameterName, $parameter)
    }

    return $runtimeParameterDictionary
}

begin {
    # Determine the XDG_DATA_HOME directory
    $xdgDataHome = $env:XDG_DATA_HOME
    if (-not $xdgDataHome) {
        if ($IsMacOS -or $IsLinux) {
            $xdgDataHome = "${HOME}/.local/share"
        }
        else {
            $xdgDataHome = $env:LOCALAPPDATA
        }
    }

    if ($IsWindows) {
        $script:InstallerArgs += '/S'

        if ($PSBoundParameters.Scope -eq 'AllUsers') {
            $script:InstallerArgs += '/InstallationType=AllUsers'
        } else {
            $script:InstallerArgs += '/InstallationType=JustMe'
        }
        if ($PSBoundParameters.AddToPath) {
            $script:InstallerArgs += '/AddToPath=1'
        } else {
            $script:InstallerArgs += '/AddToPath=0'
        }
        if ($PSBoundParameters.RegisterPython) {
            $script:InstallerArgs += '/RegisterPython=1'
        } else {
            $script:InstallerArgs += '/RegisterPython=0'
        }
        if ($PSBoundParameters.NoRegistry) {
            $script:InstallerArgs += '/NoRegistry=1'
        } else {
            $script:InstallerArgs += '/NoRegistry=0'
        }
    }

    if (-not $IsWindows) {
        $script:InstallerArgs += '-b'
        $script:InstallerArgs += '-u'

        if ($PSBoundParameters.Prefix) {
            $script:InstallerArgs += "-p"
            $script:InstallerArgs += $PSBoundParameters.Prefix
        }
    }

    # Generate a unique temporary directory to store downloaded files
    $tempFile = [System.IO.Path]::GetTempFileName()
    $tempPath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($tempFile), [System.IO.Path]::GetFileNameWithoutExtension($tempFile))
    $null = [System.IO.Directory]::CreateDirectory($tempPath)
    [System.IO.File]::Delete($tempFile)
    Write-Verbose "Using temporary directory: $tempPath"
}

process {
    try {
        Write-Verbose "Installing Miniconda 3."

        if ($IsWindows) {
            curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe -o $tempPath/miniconda.exe
            Start-Process -FilePath $tempPath/miniconda.exe -Wait -ArgumentList $script:InstallerArgs
            Remove-Item -Force $tempPath/miniconda.exe -ErrorAction SilentlyContinue
        } elseif ($IsLinux) {
            wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $tempPath/miniconda.sh
            bash $tempPath/miniconda.sh @script:InstallerArgs
            Remove-Item -Force $tempPath/miniconda.sh -ErrorAction SilentlyContinue
        } elseif ($IsMacOS) {
            curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o $tempPath/miniconda.sh
            bash $tempPath/miniconda.sh @script:InstallerArgs
            Remove-Item -Force $tempPath/miniconda.sh -ErrorAction SilentlyContinue
        } else {
            throw 'Unsupported platform.'
        }
    }
    catch {
        if ([System.IO.Directory]::Exists($tempPath)) {
            Write-Verbose "Removing temporary directory: $tempPath"
            [System.IO.Directory]::Delete($tempPath, $true)
        }
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

end {
    if ([System.IO.Directory]::Exists($tempPath)) {
        Write-Verbose "Removing temporary directory: $tempPath"
        [System.IO.Directory]::Delete($tempPath, $true)
    }
}
