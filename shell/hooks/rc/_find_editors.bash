#!/usr/bin/env bash


# First, the major binaries.
VSCODE="$(find_binary "code")" || VSCODE=''
if [ -z "$VSCODE" ]; then
    append_profile_suggestions "# TODO: 🧑‍💻 Install VSCode. See: https://code.visualstudio.com/docs/setup/linux."
    unset VSCODE;
else export VSCODE; fi

NANO="$(find_binary "nano")" || NANO=''
if [ -z "$NANO" ]; then
    append_profile_suggestions "# TODO: ⌨️ Install \`nano\`."
    unset NANO;
else export NANO; fi

NEOVIM="$(find_binary "nvim")" || NEOVIM=''
if [ -z "$NEOVIM" ]; then
    append_profile_suggestions "# TODO: 🤷 Add \`nvim\` to your PATH."
    unset NEOVIM;
else export NEOVIM; fi

VIM="$(find_binary "vim")" || VIM=''
if [ -z "$VIM" ]; then
    append_profile_suggestions "# TODO: 🤷 Add \`vim\` to your PATH."
    unset VIM;
else export VIM; fi

VI="$(find_binary "vi")" || VI=''
if [ -z "$VI" ]; then
    append_profile_suggestions "# TODO: 🤷 Add \`vi\` to your PATH."
    unset VI;
else export VI; fi


if [ -n "$NANO" ]; then
# Let's see what `nano` is capable of on this system.
    grep_bin="$(find_binary "grep")"
    nano_help="$($NANO -h)" || return 3
    EDITOR_NANO_ARGS=(--stateflags --linenumbers --noconvert --minibar --magic --positionlog --indicator)
    for i in "${EDITOR_NANO_ARGS[@]}"
    do
        NANO_HAS_PARAM=$(echo "$nano_help" | $grep_bin -e "$i" -) || NANO_HAS_PARAM=''
        if [ -z "$NANO_HAS_PARAM" ]; then
            EDITOR_NANO_ARGS=( "${EDITOR_NANO_ARGS[@]/$i}" )
        fi
    done
    unset NANO_HAS_PARAM
    unset nano_help
    unset grep_bin
fi


if [ -n "$NANO" ] && [ -z "$SSH_CONNECTION" ]; then
    # If nano exists and we aren't in an SSH connection, let's try to use a mouse.
    EDITOR_NANO_ARGS+=("--mouse")
fi

if [ -n "$VSCODE" ] && [ -n "$VSCODE_IPC_HOOK_CLI" ]; then
    # If we are in VSCode's embedded terminal, let's try to reuse the window.
    VSCODE_ARGS=(--reuse-window --wait)
elif [ -n "$VSCODE" ]; then
    # If we are NOT in VSCode's embedded terminal, let's always open a new window.
    VSCODE_ARGS=(--new-window --wait)
fi

if [[ -n "$VSCODE" && -z "$SSH_CONNECTION" && ( -z "$WSL_DISTRO_NAME" || "$TERM_PROGRAM" = "vscode" ) ]]; then
    # If VSCode exists and we aren't remotely connected (or in a non-VSCode-hosted WSL session), let's use it.
    # We don't want to use VSCode from within WSL if we aren't also running in a VSCode terminal.
    # Because it's waaaay too slow in those cases.
    EDITOR="$VSCODE ${VSCODE_ARGS[*]}"
elif [ -n "$NANO" ]; then
    # If nano exists, let's use it.
    # We don't pass in $EDITOR_NANO_ARGS because we've included it in the alias above.
    EDITOR="$NANO"
elif [ -n "$NEOVIM" ]; then
    # If neovim exists, let's use it.
    EDITOR="NEOVIM"
elif [ -n "$VIM" ]; then
    # If vim exists, let's use it.
    EDITOR="$VIM"
elif [ -n "$VI" ]; then
    # If vi exists, let's use it.
    EDITOR="$VI"
elif [ -n "$EDITOR" ]; then
    : # If $EDITOR is set, let's use it as-is.
else
    # Fallback to something every system probably has.
    EDITOR="ed"
fi
if [ -n "$EDITOR" ]; then
    export EDITOR
else
    unset EDITOR
fi
