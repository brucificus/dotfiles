#!/usr/bin/env zsh
# shellcheck source-path=SCRIPTDIR/../../funcs


if command_exists code; then
    plugins+=(vscode)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vscode
fi
