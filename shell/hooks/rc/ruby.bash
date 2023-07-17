#!/usr/bin/env bash


if binary_exists ruby; then
    alias rb='ruby'
else
    append_profile_suggestions "# TODO: 💎 Add \`ruby\` to your PATH."
fi
