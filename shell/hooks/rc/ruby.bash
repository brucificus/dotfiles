#!/usr/bin/env bash


if binary_exists ruby; then
    alias rb='ruby'
else
    append_profile_suggestions "# TODO: 💎 Install \`ruby\`. See: https://www.ruby-lang.org/en/documentation/installation/."
fi
