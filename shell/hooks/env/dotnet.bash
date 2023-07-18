#!/usr/bin/env bash


if [ -z "${DOTNET_ROOT}" ] && [ -d "${HOME}/.dotnet" ]; then
    export DOTNET_ROOT="${HOME}/.dotnet"
elif [ -z "${DOTNET_ROOT}" ] && [ -d "/usr/share/dotnet" ]; then
    export DOTNET_ROOT="/usr/share/dotnet"
elif [ -z "${DOTNET_ROOT}" ] && [ -d "/usr/lib/dotnet" ]; then
    export DOTNET_ROOT="/usr/lib/dotnet"
fi

if [ -n "${DOTNET_ROOT}" ] && ! command_exists dotnet; then
    path_append "${DOTNET_ROOT}"
    path_append "${DOTNET_ROOT}/tools"
fi

if command_exists dotnet; then
    if [ -z "${NUGET_PACKAGES}" ]; then
        # The global packages folder.
        export NUGET_PACKAGES="${XDG_CACHE_HOME}/nuget-packages"
        mkdir -p "$NUGET_PACKAGES" > /dev/null 2>&1 || return 1

        old_profile_nuget_packages_location="$HOME/.nuget/packages"
        if [ -d "$old_profile_nuget_packages_location" ] && [ ! -L "$old_profile_nuget_packages_location" ]; then
            mv "$old_profile_nuget_packages_location"/* "$NUGET_PACKAGES" > /dev/null 2>&1 || return 1
            rmdir "$old_profile_nuget_packages_location" > /dev/null 2>&1 || return 1
            ln -s "$NUGET_PACKAGES" "$old_profile_nuget_packages_location" > /dev/null 2>&1 || return 1
        fi
        unset old_profile_nuget_packages_location
    fi

    # Specifies that data about the .NET tools usage should *not* be collected and sent to Microsoft.
    export DOTNET_CLI_TELEMETRY_OPTOUT=1

    # Mutes the .NET welcome message on "first run".
    export DOTNET_NOLOGO=1

    # The NuGetFallbackFolder won't be expanded to disk and a shorter welcome message is shown.
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
fi
