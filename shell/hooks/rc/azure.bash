#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if command_exists az; then
    if [ -n "$BASH_VERSION" ]; then
        : # load_bashit_xyz def
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            azure  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/azure
        )
    fi
elif command_exists terraform || command_exists packer; then
    append_profile_suggestions "# TODO: ☁️ Install the Azure CLI. See: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli."
fi
