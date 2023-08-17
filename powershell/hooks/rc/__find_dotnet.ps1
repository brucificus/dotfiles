#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$ds = [System.IO.Path]::DirectorySeparatorChar

if (-not $IsWindows) {
    if ((-not $Env:DOTNET_ROOT) -and ( Test-d "${HOME}${ds}.dotnet" )) {
        Set-EnvVar -Process -Name DOTNET_ROOT -Value "${HOME}${ds}.dotnet"
    } elseif ((-not $Env:DOTNET_ROOT) -and ( Test-d "/usr/share/dotnet" )) {
        Set-EnvVar -Process -Name DOTNET_ROOT -Value "/usr/share/dotnet"
    } elseif ((-not $Env:DOTNET_ROOT) -and ( Test-d "/usr/lib/dotnet" )) {
        Set-EnvVar -Process -Name DOTNET_ROOT -Value "/usr/lib/dotnet"
    }
}

if (($Env:DOTNET_ROOT) -and (-not (Test-Command dotnet))) {
    Add-EnvPathItem -Process -Value $Env:DOTNET_ROOT
    Add-EnvPathItem -Process -Value "${Env:DOTNET_ROOT}${ds}tools"
}

if (Test-Command dotnet) {
    # https://learn.microsoft.com/en-us/nuget/consume-packages/managing-the-global-packages-and-cache-folders

    if (-not $Env:NUGET_PACKAGES) {
        $default_nuget_packages_location = "${HOME}${ds}.nuget${ds}packages"
        if ($IsWindows) {
            Set-EnvVar -Process -Name NUGET_PACKAGES -Value $default_nuget_packages_location
        } else {
            # The global packages folder.
            Set-EnvVar -Process -Name NUGET_PACKAGES -Value "$Env:XDG_CACHE_HOME${ds}nuget-packages"
            mkdir -p $Env:NUGET_PACKAGES | Out-Null

            if ((Test-d $default_nuget_packages_location) -and ( -not (Test-L $default_nuget_packages_location) )) {
                mv $default_nuget_packages_location/* $Env:NUGET_PACKAGES | Out-Null
                rmdir $default_nuget_packages_location | Out-Null
                ln -s $Env:NUGET_PACKAGES $default_nuget_packages_location | Out-Null
            }
        }
    }

    # if (-not $Env:NUGET_HTTP_CACHE_PATH) {
    # }

    # if (-not $Env:NUGET_SCRATCH) {
    # }

    # if (-not $Env:NUGET_PLUGINS_CACHE_PATH) {
    # }

    # Specifies that data about the .NET tools usage should *not* be collected and sent to Microsoft.
    Set-EnvVar -Process -Name DOTNET_CLI_TELEMETRY_OPTOUT -Value 1

    # Mutes the .NET welcome message on "first run".
    Set-EnvVar -Process -Name DOTNET_NOLOGO -Value 1

    # The NuGetFallbackFolder won't be expanded to disk and a shorter welcome message is shown.
    Set-EnvVar -Process -Name DOTNET_SKIP_FIRST_TIME_EXPERIENCE -Value 1
}
