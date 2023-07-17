#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if [ -n "$BASH_VERSION" ]; then
    source "$BASHIT_PLUGINS_AVAILABLE"/colors.plugin.bash || return $?
    source "$BASHIT_PLUGINS_AVAILABLE"/man.plugin.bash || return $?
    source "$BASHIT_PLUGINS_AVAILABLE"/tmux.plugin.bash || return $?
elif [ -n "$ZSH_VERSION" ]; then
    if [ -z "${plugins[*]}" ]; then plugins=(); fi
    plugins+=(
        colors  # https://github.com/zpm-zsh/colors
        colored-man-pages  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages
        colorize  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colorize
        emoji  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/emoji
        emotty  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/emotty
        zsh-syntax-highlighting  # https://github.com/zsh-users/zsh-syntax-highlighting
        zsh-256color  # https://github.com/chrissicool/zsh-256color
    )
    # Notes about `colorize`:
    #  - `colorize` plugin prefers `pygmentize` over `chroma`, but can override with `ZSH_COLORIZE_TOOL`.
    #  - There are additional options for `colorize`, see the link.
    #  - It defines commands `ccat`(`colorize_cat`) and `cless`(`colorize_less`).

    # TODO: TBD: Consider integrating `ccat` & `cless` with (or replacing) `batcat`.
    # TODO: Consider porting them to Bash.

    if ! command_exists pygmentize && ! command_exists chroma; then
        append_profile_suggestions "# TODO: 🌈 Install \`Pygments\` or \`Chroma\`. See: https://pygments.org/download/ or https://github.com/alecthomas/chroma/releases/."
    fi
fi
