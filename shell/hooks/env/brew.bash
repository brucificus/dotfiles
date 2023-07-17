#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if [ -x ~/.linuxbrew/bin/brew ]; then
    eval "$(~/.linuxbrew/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif ! command_exists brew; then
    append_profile_suggestions "# TODO: 🍺 Install \`brew\`. See: https://docs.brew.sh/Homebrew-on-Linux"
fi
