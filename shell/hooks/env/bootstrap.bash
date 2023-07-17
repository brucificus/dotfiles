#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# For user-specific executable files.
path_prepend "$HOME/.local/bin"  # This is an XDG default, actually. (It just doesn't have a dedicated variable name.)
path_prepend "$HOME/.dotfiles/bin"

# If we're in WSL, we need to do some specific PATH patching.
if [ -n "$WSL_DISTRO_NAME" ]; then
    windows_python_scripts_pattern='^/mnt/.*Python.*/Scripts'
    path_removematch "$windows_python_scripts_pattern"; export PATH
    unset windows_python_scripts_pattern

    WINDOWS_USER="$(cmd.exe /c echo %USERNAME% 2>/dev/null | tr -d '\r')"; export WINDOWS_USER
    WINDOWS_HOME="$(wslpath -u "$(cmd.exe /c echo %USERPROFILE% 2>/dev/null | tr -d '\r')")"; export WINDOWS_HOME
fi


PROFILE_SUGGESTIONS=''; export PROFILE_SUGGESTIONS
if [ ! "$(shell_actual)" = 'zsh' ]; then
    if ! command_exists zsh; then
        append_profile_suggestions "# TODO: ⚡ Install \`zsh\`. See: https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH."
        append_profile_suggestions "# TODO: ⚡ Set your default shell to \`zsh\`. (\`chsh -s \"\$(which zsh)\"\`)"
    else
        append_profile_suggestions "# TODO: ⚡ Set your default shell to \`zsh\`. (\`chsh -s \"\$(which zsh)\"\`)"
    fi
fi
