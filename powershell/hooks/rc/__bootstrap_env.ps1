#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$ds=[System.IO.Path]::DirectorySeparatorChar

#
# HOME
#

if ((-not (Test-Path Env:\HOME -ErrorAction SilentlyContinue)) -or (-not $HOME)) {
    if (Test-Path Env:\USERPROFILE -ErrorAction SilentlyContinue) {
        Set-EnvVar -Process -Name HOME -Value "${Env:USERPROFILE}"
    }
}


#
# IsWSL
#

if (-not (Get-Variable -Name IsWSL -ErrorAction SilentlyContinue)) {
    if ($Env:WSL_DISTRO_NAME) {
        Set-Variable -Name IsWSL -Value $true -Option AllScope,Constant
    } elseif ($IsLinux -and (Test-Command wslpath) -and (Test-Command cmd.exe)) {
        Set-Variable -Name IsWSL -Value $true -Option AllScope,Constant
    } else {
        Set-Variable -Name IsWSL -Value $false -Option AllScope,Constant
    }
}


#
# TEMP
#

if (-not $Env:TEMP) {
    Set-EnvVar -Process -Name TEMP -Value ([System.IO.Path]::GetTempPath())
}


#
# WINDOWS_* (WSL only)
#

if ($IsWSL) {
    # Let's grab some helpful variables.
    Set-EnvVar -Process -Name WINDOWS_USERNAME -Value (cmd.exe /c echo "%USERNAME%" 2> $null).Trim()
    Set-EnvVar -Process -Name WINDOWS_USERPROFILE -Value (wslpath -u (cmd.exe /c echo "%USERPROFILE%" 2> $null).Trim())
    Set-EnvVar -Process -Name WINDOWS_ProgramData -Value (wslpath -u (cmd.exe /c echo "%ProgramData%" 2> $null).Trim())
    Set-EnvVar -Process -Name WINDOWS_ProgramFiles -Value (wslpath -u (cmd.exe /c echo "%ProgramFiles%" 2> $null).Trim())
    Set-EnvVar -Process -Name WINDOWS_ProgramFiles_x86 -Value (wslpath -u (cmd.exe /c echo "%ProgramFiles(x86)%" 2> $null).Trim())
    Set-EnvVar -Process -Name WINDOWS_SystemRoot -Value (wslpath -u (cmd.exe /c echo "%SystemRoot%" 2> $null).Trim())
    Set-EnvVar -Process -Name WINDOWS_LOCALAPPDATA -Value (wslpath -u (cmd.exe /c echo "%LOCALAPPDATA%" 2> $null).Trim())
    Set-EnvVar -Process -Name WINDOWS_ProgramW6432 -Value (wslpath -u (cmd.exe /c echo "%ProgramW6432%" 2> $null).Trim())

    Set-EnvVar -Process -Name WINDOWS_Path -Value (cmd.exe /c echo "%Path%" 2> $null).Trim()
    Set-EnvVar -Process -Name WINDOWS_Path -Value (@(@($Env:WINDOWS_Path -split ";") | ForEach-Object { wslpath -u $_ }) -join [System.IO.Path]::PathSeparator)
}


#
# PATH
#

Add-EnvPathItem -Process -Value "$HOME${ds}.dotfiles${ds}bin" -Prepend
Add-EnvPathItem -Process -Value "$HOME${ds}.local${ds}bin" -Prepend  # This is an XDG default, actually. (It just doesn't have a dedicated variable name.)

# Clear Windows-isms from the PATH.
# This prevents us from accidentally running the Windows versions of certain programs.
# This also *massively* speeds up command resolution in WSL.
if ($IsWSL) {
    [string[]] $prefixesOfPathsToRemove = @(
        $Env:WINDOWS_ProgramData,
        $Env:WINDOWS_ProgramFiles,
        $Env:WINDOWS_ProgramFiles_x86,
        $Env:WINDOWS_SystemRoot,
        $Env:WINDOWS_LOCALAPPDATA,
        $Env:WINDOWS_ProgramW6432,
        "${Env:WINDOWS_USERPROFILE}/scoop",
        "${Env:WINDOWS_USERPROFILE}/.dotnet"
    ) | Select-Object -Unique
    [string[]] $allowList = @(
        "*Microsoft VS Code*"
    )
    Get-EnvPathItem -Process | ForEach-Object {
        foreach ($prefix in $prefixesOfPathsToRemove) {
            if ($_.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
                [bool] $isAllowed = $false
                foreach ($allow in $allowList) {
                    if ($_ -like $allow) {
                        $isAllowed = $true
                        break
                    }
                }
                if (-not $isAllowed) {
                    Remove-EnvPathItem -Process -Value $_
                }
                break
            }
        }
    }
}

function Get-EnvPathItemProcessScoped {
    Get-EnvPathItem -Process
}

Set-Alias -Name path -Value Get-EnvPathItemProcessScoped


#
# PSModulePath
#

Add-EnvVarPathItem -Process -Name "PSModulePath" -Value (Resolve-Path "$PSScriptRoot/../../modules")
Add-EnvVarPathItem -Process -Name "PSModulePath" -Value (Resolve-Path "$PSScriptRoot/../../internal-modules")

if ($IsCoreCLR) {
    # Take folders from PSModulePath that are for Windows PowerShell only,
    # and make sure they are at the _end_ of the PSModulePath.
    [string[]] $psmoduleEntriesForWindowsPowerShell = Get-EnvVarPathItem -Process -Name "PSModulePath" | Where-Object { $_ -like "*WindowsPowerShell*" }
    $psmoduleEntriesForWindowsPowerShell | Add-EnvVarPathItem -Process -Name "PSModulePath"
    Remove-Variable -Name psmoduleEntriesForWindowsPowerShell
}

function Get-EnvPSModulePathItemProcessScoped {
    Get-EnvVarPathItem -Process -Name "PSModulePath"
}

Set-Alias -Name psmodulepath -Value Get-EnvPSModulePathItemProcessScoped


#
# SHORT_HOST, SHORT_HOSTNAME
#
# These are used by tools to refer to the host without the domain name.
# (xterm, screen, tmux, etc.)
#
if (-not $Env:SHORT_HOST -and ($Env:SHORT_HOSTNAME)) {
    Set-EnvVar -Process -Name SHORT_HOST -Value $Env:SHORT_HOSTNAME
} elseif (-not $Env:SHORT_HOSTNAME -and ($Env:SHORT_HOST)) {
    Set-EnvVar -Process -Name SHORT_HOSTNAME -Value $Env:SHORT_HOST
} elseif (-not $Env:SHORT_HOST -and -not $Env:SHORT_HOSTNAME) {
    [string] $macosComputerName = $null
    [string] $windowsHostnameCorrectlyCased = $null
    [string] $hostnameShort = $null
    if ($IsMacOS) {
        # macOS's $HOST changes with dhcp, etc. Use ComputerName if possible.
        $macosComputerName = (scutil --get ComputerName 2> $null)
    } elseif ($IsWindows) {
        $windowsHostnameCorrectlyCased = (Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters).Hostname
    } elseif (Test-Command hostname -ExecutableOnly) {
        $hostnameShort = (hostname -s 2> $null)
    }

    if ($macosComputerName) {
        Set-EnvVar -Process -Name SHORT_HOST -Value $macosComputerName
    } elseif ($windowsHostnameCorrectlyCased) {
        Set-EnvVar -Process -Name SHORT_HOST -Value ($windowsHostnameCorrectlyCased -replace '\..*','')
    } elseif ($hostnameShort) {
        Set-EnvVar -Process -Name SHORT_HOST -Value $hostnameShort
    } elseif ($Env:HOST) {
        Set-EnvVar -Process -Name SHORT_HOST -Value ($Env:HOST -replace '\..*','')
    } elseif ($Env:COMPUTERNAME) {
        Set-EnvVar -Process -Name SHORT_HOST -Value ($Env:COMPUTERNAME -replace '\..*','')
    } else {
        Set-EnvVar -Process -Name SHORT_HOST -Value "localhost"
    }
    Set-EnvVar -Process -Name SHORT_HOSTNAME -Value $Env:SHORT_HOST
}


#
# XDG
#

Import-Module poshy-sh-isms -DisableNameChecking
Import-Module poshy-coreutils-ish -DisableNameChecking

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# https://stackoverflow.com/a/49783629

# Defines the base directory relative to which user-specific data files should be stored.
if (-not $Env:XDG_DATA_HOME) {
    if ($IsWindows) {
        Set-EnvVar -Process -Name XDG_DATA_HOME -Value $Env:LOCALAPPDATA
    } else {
        Set-EnvVar -Process -Name XDG_DATA_HOME -Value "$HOME${ds}.local${ds}share"
    }
}

# Defines the base directory relative to which user-specific configuration files should
# be stored.
if (-not $Env:XDG_CONFIG_HOME) {
    if ($IsWindows) {
        Set-EnvVar -Process -Name XDG_CONFIG_HOME -Value $Env:LOCALAPPDATA
    } else {
        Set-EnvVar -Process -Name XDG_CONFIG_HOME -Value "$HOME${ds}.config"
    }
}
# This directory gets a lot of use by Bash-It and Oh-My-Zsh stuff (and problably other
# tools/frameworks too), and not usually in a way that references $Env:XDG_CONFIG_HOME.
# So think hard before changing the value of this variable, because those tools will
# still be writing to this directory directly.

# Defines the base directory relative to which user-specific state files should be stored.
# Contains state data that should persist between (application) restarts, but that is not
# important or portable enough to the user that it should be stored in $Env:XDG_DATA_HOME
if (-not $Env:XDG_STATE_HOME) {
    if ($IsWindows) {
        # TODO: Research or invent a Windows equivalent.
    } else {
        Set-EnvVar -Process -Name XDG_STATE_HOME -Value "$HOME${ds}.local${ds}state"
    }
}

# Defines the preference-ordered set of base directories to search for data files in addition
# to the $Env:XDG_DATA_HOME base directory. Entries should be separated with the platform's path separator.
if ($IsWindows) {
    Add-EnvVarPathItem -Process -Name XDG_DATA_DIRS -Value "$HOME${ds}.local${ds}share"
    Add-EnvVarPathItem -Process -Name XDG_DATA_DIRS -Value $Env:APPDATA
    Add-EnvVarPathItem -Process -Name XDG_DATA_DIRS -Value $Env:PROGRAMDATA
} else {
    Add-EnvVarPathItem -Process -Name XDG_DATA_DIRS -Value "/usr/local/share"
    Add-EnvVarPathItem -Process -Name XDG_DATA_DIRS -Value "/usr/share"
}

# Defines the preference-ordered set of base directories to search for configuration files in
# addition to the $Env:XDG_CONFIG_HOME base directory. Entries should be separated with a colon ':'.
if ($IsWindows) {
    Add-EnvVarPathItem -Process -Name XDG_CONFIG_DIRS -Value "$HOME${ds}.config"
    Add-EnvVarPathItem -Process -Name XDG_CONFIG_DIRS -Value $Env:APPDATA
    Add-EnvVarPathItem -Process -Name XDG_CONFIG_DIRS -Value $Env:PROGRAMDATA
} else {
    Add-EnvVarPathItem -Process -Name XDG_CONFIG_DIRS -Value "/etc/xdg"
}

# Defines the base directory relative to which user-specific non-essential data files should
# be stored.
if ($IsWindows) {
    Set-EnvVar -Process -Name XDG_CACHE_HOME -Value ([System.IO.Path]::GetTempPath())
} else {
    Set-EnvVar -Process -Name XDG_CACHE_HOME -Value "$HOME${ds}.cache"
}

# Defines the base directory relative to which user-specific runtime files and other file
# objects should be stored. This directory is used to store volatile runtime files and
# other file objects (such as sockets, named pipes, ...), and should be cleaned out
# whenever the user logs out.

# See:
#     - https://unix.stackexchange.com/a/477049
# and - https://unix.stackexchange.com/a/580757

if ($IsWindows) {
    append_profile_suggestions "# TODO: ⚠️ Implement '`$Env:XDG_RUNTIME_DIR' for Windows."
} else {
    [System.IO.UnixFileMode] $expected_mode = [System.IO.UnixFileMode]::UserExecute && [System.IO.UnixFileMode]::UserWrite && [System.IO.UnixFileMode]::UserExecute
    if (-not $Env:XDG_RUNTIME_DIR) {
        # TODO: Research or invent a Windows equivalent.
        [string] $canonically_default_path = "/run/user/${Env:UID}"
        if (Test-d $canonically_default_path) {
            Set-EnvVar -Process -Name XDG_RUNTIME_DIR -Value $canonically_default_path
        } else {
            # If systemd didn't make a directory for us, we'll use /tmp
            # TODO: Research or invent a Windows equivalent.
            Set-EnvVar -Process -Name XDG_RUNTIME_DIR -Value "/tmp/${Env:USER}-runtime"

            if (-not (Test-d $Env:XDG_RUNTIME_DIR)) {
                New-Item -ItemType Directory -Name $Env:XDG_RUNTIME_DIR | Out-Null
                if (-not $IsWindows) {
                    $expected_mode_octal = ConvertFrom-NixMode -Mode $expected_mode -ToOctal
                    chmod $expected_mode_octal $Env:XDG_RUNTIME_DIR
                }
            }
        }
    }

    # Check dir has got the correct type, ownership, and permissions.
    if ( -not ((Test-d $Env:XDG_RUNTIME_DIR) -and (Test-O $Env:XDG_RUNTIME_DIR) -and ((Get-ItemNixMode $Env:XDG_RUNTIME_DIR) -eq $expected_mode)) ) {
        append_profile_suggestions "# TODO: ⚠️ Fix permissions problem with: $Env:XDG_RUNTIME_DIR"
        # TODO: Research or invent a Windows equivalent.
        Set-EnvVar -Process -Name XDG_RUNTIME_DIR -Value (mktemp -d "/tmp/${Env:USER}-runtime-XXXXXX")
    }
}


if ((-not $IsWindows) -and (-not (Test-Command "zsh"))) {
    append_profile_suggestions "# TODO: ⚡ Install 'zsh'. See: https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH."
}


#
# Pwsh-isms
#

$psgalleryRepository = Get-PSRepository PSGallery -ErrorAction SilentlyContinue
if ($psgalleryRepository -and $psgalleryRepository.InstallationPolicy -ne "Trusted") {
    append_profile_suggestions "# TODO: ⚠️ ``Set-PSRepository -Name PSGallery -InstallationPolicy Trusted``."
}
Remove-Variable -Name psgalleryRepository

Remove-Variable -Name ds
