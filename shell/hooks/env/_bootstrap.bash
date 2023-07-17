#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# For user-specific executable files.
path_prepend "$HOME/.local/bin"  # This is an XDG default, actually. (It just doesn't have a dedicated variable name.)
path_prepend "$HOME/.dotfiles/bin"


PROFILE_SUGGESTIONS=''; export PROFILE_SUGGESTIONS
if [ ! "$(shell_actual)" = 'zsh' ]; then
    if ! command_exists zsh; then
        append_profile_suggestions "# TODO: ⚡ Install \`zsh\`. See: https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH."
        append_profile_suggestions "# TODO: ⚡ Set your default shell to \`zsh\`. (\`chsh -s \"\$(which zsh)\"\`)"
    else
        append_profile_suggestions "# TODO: ⚡ Set your default shell to \`zsh\`. (\`chsh -s \"\$(which zsh)\"\`)"
    fi
fi
