#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/aliases/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/completion/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/plugins/available


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi

if command_exists convert; then  # from ImageMagick.
    if [ -n "$BASH_VERSION" ]; then
        function catimg() {
            if [[ -x "$(which convert)" ]]; then
                ~/.dotfiles/shell/vendor/oh-my-zsh/plugins/catimg/catimg.sh "$@"
            else
                echo "catimg need convert (ImageMagick) to work)" >2
            fi
        }
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            catimg  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/catimg
        )
    fi
else
    append_profile_suggestions "# TODO: ⚙️ Add \`convert\` (from ImageMagick) to your PATH."
fi

if ! command_exists catimg; then
    append_profile_suggestions "# TODO: 🖼️ Install \`catimg\`. See: https://github.com/posva/catimg#installation."
fi

if ! command_exists asciinema; then
    append_profile_suggestions "# TODO: 📽️ Install \`asciinema\`. See: https://github.com/asciinema/asciinema#quick-intro."
fi

if [ -n "$BASH_VERSION" ]; then
    source "$BASHIT_PLUGINS_AVAILABLE"/browser.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/browser.plugin.bash
    source "$BASHIT_PLUGINS_AVAILABLE"/extract.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/extract.plugin.bash
elif [ -n "$ZSH_VERSION" ]; then
    plugins+=(
        extract  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/extract
        jsontools  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/jsontools
        universalarchive  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/universalarchive
    )

    if command_exists jq; then
        if command_exists fzf; then
            plugins+=(
                jq  # https://github.com/reegnz/jq-zsh-plugin
            )
        else
            append_profile_suggestions "# TODO: 🔎 Install \`fzf\`. See: https://github.com/junegunn/fzf#installation."
        fi
    else
        append_profile_suggestions "# TODO: 📝 Install \`jq\`. See: https://jqlang.github.io/jq/download/."
    fi
fi

if command_exists fzf; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/fzf.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/browser.plugin.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            fzf  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fzf
        )
    fi
elif ! command_exists jq; then
    append_profile_suggestions "# TODO: 🔎 Install \`fzf\`. See: https://github.com/junegunn/fzf#installation."
fi

if command_exists jq && ! command_exists yq; then
    append_profile_suggestions "# TODO: 📝 Install \`yq\`. See: https://github.com/mikefarah/yq#install."
fi
