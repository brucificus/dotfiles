#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$ds=[System.IO.Path]::DirectorySeparatorChar
$ps=[System.IO.Path]::PathSeparator

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

if ($Env:WSL_DISTRO_NAME) {
    Set-Variable -Name IsWSL -Value $true -Option AllScope
} elseif ($IsLinux -and (Test-Command wslpath) -and (Test-Command cmd.exe)) {
    Set-Variable -Name IsWSL -Value $true -Option AllScope
} else {
    Set-Variable -Name IsWSL -Value $false -Option AllScope
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
    Set-EnvVar -Process -Name WINDOWS_Path -Value (@(@($Env:WINDOWS_Path -split ";") | ForEach-Object { wslpath -u $_ }) -join $ps)
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

Add-EnvVarPathItem -Process -Name "PSModulePath" -Value "$PSScriptRoot/../../modules"
Add-EnvVarPathItem -Process -Name "PSModulePath" -Value "$PSScriptRoot/../../internal-modules"

if ($IsCoreCLR) {
    # Remove folders from PSModulePath that are for Windows PowerShell only.
    # We don't want those modules conflicting with our PowerShell Core modules.
    Get-EnvVarPathItem -Process -Name "PSModulePath" | ForEach-Object {
        if ($_ -like "*WindowsPowerShell*") {
            Remove-EnvVarPathItem -Process -Name "PSModulePath" -Value $_
        }
    }

    # If modules already have been loaded from the wrong folders, let's attempt to unload them.
    # NOTE: This doesn't (can't) remove loaded assemblies, so it's not a perfect solution.
    Get-Module | ForEach-Object {
        if ($_.Path -like "*WindowsPowerShell*") {
            Remove-Module -Name $_.Name -Force -ErrorAction SilentlyContinue | Out-Null
            append_profile_suggestions "# TODO: ⚠️ Prevent module '$($_.Name)' from loading from '$($_.Path)'."
        }
    }
}

function Get-EnvPSModulePathItemProcessScoped {
    Get-EnvVarPathItem -Process -Name "PSModulePath"
}

Set-Alias -Name psmodulepath -Value Get-EnvPSModulePathItemProcessScoped


#
# XDG
#

Import-Module poshy-posix-isms -DisableNameChecking
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
                    Set-ItemNixMode -Path $Env:XDG_RUNTIME_DIR -Mode $expected_mode
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