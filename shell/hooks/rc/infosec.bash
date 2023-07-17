#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if [ -n "$BASH_VERSION" ]; then
    : # 🙁
elif [ -n "$ZSH_VERSION" ]; then
    plugins+=(
        gpg-agent  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gpg-agent
        encode64  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/encode64
    )
fi

if command_exists keychain; then
    if [ -n "$BASH_VERSION" ]; then
        : # 🙁
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            keychain  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/keychain
        )
    fi
else
    append_profile_suggestions "# TODO: 🔑 Install \`keychain\`. See: https://www.funtoo.org/Keychain#Quick_Setup."
fi
