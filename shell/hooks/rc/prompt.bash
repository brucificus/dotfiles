#!/usr/bin/env bash


if command_exists "oh-my-posh"; then
    # Use oh-my-posh for prompt customization.
    load_ohmyposh_theme "$PWD/../../../theme.omp.yaml"
fi
