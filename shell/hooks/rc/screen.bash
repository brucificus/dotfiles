#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi

if ! command_exists screen; then
    append_profile_suggestions "# TODO: ⚡ Install \`screen\`."
    return 0;
fi


# cd replacement for screen to track cwd (like tmux)
scr_cd()
{
    builtin cd "$1" || return $?
    screen -X chdir "$PWD"
}

if [ -n "$STY" ]; then
    alias cd=scr_cd
fi

if [ -n "$BASH_VERSION" ]; then
    : # 🙁
elif [ -n "$ZSH_VERSION" ]; then
    plugins+=(
        screen  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/screen
    )
fi
