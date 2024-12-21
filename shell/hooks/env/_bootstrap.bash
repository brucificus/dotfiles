#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# For user-specific executable files.
# FYI: We rely on our Dotbot configuration to create symlinks for files from "<this repo>/bin" into "$HOME/.local/bin".
path_prepend "$HOME/.local/bin"  # This is a notable location in the XDG standard, it just doesn't have a dedicated environment variable name in that spec.


PROFILE_SUGGESTIONS=''; export PROFILE_SUGGESTIONS
if [ ! "$(shell_actual)" = 'zsh' ]; then
    if ! command_exists zsh; then
        append_profile_suggestions "# TODO: ⚡ Install \`zsh\`. See: https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH."
        append_profile_suggestions "# TODO: ⚡ Set your default shell to \`zsh\`. (\`chsh -s \"\$(which zsh)\"\`)"
    else
        append_profile_suggestions "# TODO: ⚡ Set your default shell to \`zsh\`. (\`chsh -s \"\$(which zsh)\"\`)"
    fi
fi
