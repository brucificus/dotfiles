#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/aliases/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/completion/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/plugins/available


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if command_exists dotnet; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/dotnet.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(dotnet)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dotnet
    fi
else
    append_profile_suggestions "# TODO: 🔨 Install \`dotnet\`. See: https://learn.microsoft.com/en-us/dotnet/core/install/linux."
fi


if command_exists pwsh; then
    : # Intentionally left blank.
else
    append_profile_suggestions "# TODO: 🔨 Install PowerShell Core. See: https://github.com/PowerShell/PowerShell#get-powershell."
fi

