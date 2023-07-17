#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/aliases/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/completion/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/plugins/available


if command_exists git; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/git.plugin.bash
        source "$BASHIT_ALIASES_AVAILABLE"/git.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            git  # https://github.com/davidde/git
            gitfast  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gitfast
            git-auto-fetch  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-auto-fetch
        )
        GIT_AUTO_FETCH_INTERVAL=1200  # 20 minutes
        export GIT_AUTO_FETCH_INTERVAL
    fi

    if binary_exists python3 && binary_exists ruby; then
        if [ -n "$ZSH_VERSION" ]; then
            plugins+=(
                git-extra-command  # https://github.com/unixorn/git-extra-commands
            )
        else
            path_prepend "$PWD/../../vendor/zsh-custom/plugins/git-extra-commands/bin"; export PATH
        fi
    fi

    if ! command_exists git-flow; then
        append_profile_suggestions "# TODO: 🤷 Install \`git-flow\`. See: https://github.com/nvie/gitflow/wiki/Installation."
    elif [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/git_flow.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            git-flow  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-flow
        )
    fi

    if ! command_exists git-hf; then
        append_profile_suggestions "# TODO: 🐙 Install \`git-hf\`. See: https://github.com/datasift/gitflow#installation."
    elif [ -n "$BASH_VERSION" ]; then
        : # 🙁
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            git-hf  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-hubflow
        )
    fi

    if ! command_exists git-lfs; then
        append_profile_suggestions "# TODO: 🐙 Install \`git-lfs\`. See: https://github.com/git-lfs/git-lfs#installing."
    elif [ -n "$BASH_VERSION" ]; then
        : # 🙁
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            git-lfs  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-lfs
        )
    fi

    if ! command_exists git-extras; then
        append_profile_suggestions "# TODO: 🐙 Install \`git-extras\`. See: https://github.com/tj/git-extras/blob/master/Installation.md."
    elif [ -n "$BASH_VERSION" ]; then
        : # 🙁
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            git-extras  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-extras
        )
    fi

    if ! command_exists fzf; then
        append_profile_suggestions "# TODO: 🔎 Install \`fzf\`. See: https://github.com/junegunn/fzf#installation."
    elif [ -n "$BASH_VERSION" ]; then
        : # 🙁
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            forgit  # https://github.com/wfxr/forgit
        )
    fi
else
    append_profile_suggestions "# TODO: 🐙 Install \`git\`. See: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git."
fi
