# Preferred editor, with fallbacks, varying based on session context.

export VSCODE=$(command -v code)
export NANO=$(command -v nano)
export NEOVIM=$(command -v nvim)
export VIM=$(command -v vim)
export VI=$(command -v vi)

NANO_ARGS=(--stateflags --linenumbers --noconvert --minibar)
if [ "$NANO" != "" ] && [ "$SSH_CONNECTION" = "" ]; then
    # If nano exists and we aren't in an SSH connection, let's try to use a mouse.
    NANO_ARGS=(${NANO_ARGS[*]} --mouse)
fi
alias nano="nano ${NANO_ARGS[*]}"

edit() {
    if [ "$VSCODE" != "" ] && [ "$VSCODE_IPC_HOOK_CLI" != "" ]; then
        # If we are in VSCode's embedded terminal, let's try to reuse the window.
        local VSCODE_ARGS=(--reuse-window --wait)
    elif [ "$VSCODE" != "" ]; then
        # If we are NOT in VSCode's embedded terminal, let's always open a new window.
        local VSCODE_ARGS=(--new-window --wait)
    fi

    if [ "$VSCODE" != "" ] && [ "$SSH_CONNECTION" = "" ]; then
        code ${VSCODE_ARGS[*]} $@
    elif [ "$NANO" != "" ]; then
        # If nano exists, let's use it.
        # We don't pass in $NANO_ARGS because we've included it in the alias above.
        nano $@
    elif [ "$NEOVIM" != "" ]; then
        # If neovim exists, let's use it.
        nvim $@
    elif [ "$VIM" != "" ]; then
        # If vim exists, let's use it.
        vim $@
    elif [ "$VI" != "" ]; then
        # If vi exists, let's use it.
        vi $@
    else
        # Fallback to something every system probably has.
        ed $@
    fi
}

export EDITOR="edit"


# Prepare to setup viewers.
export BAT_THEME="Visual Studio Dark+"
export BATCAT=$(command -v batcat)
if [ $BATCAT = "" ]; then
    export BATCAT=$(command -v bat)
    if [ $BATCAT != "" ]; then
        alias batcat="bat"
    fi
else
    alias bat="batcat"
fi
export HEXDUMP=$(command -v hexdump)

VIEWER_BATCAT_ARGS=()
VIEWERB_BATCAT_ARGS=(${VIEWER_BATCAT_ARGS[*]} --show-all)

VIEWER_NANO_ARGS=(--view)

VIEWER_CAT_ARGS=(--number)
VIEWERB_CAT_ARGS=(${VIEWER_CAT_ARGS[*]} --show-all)


# Preferred viewer, with fallbacks.
# We don't use VSCode because it doesn't currently support being launched in a read-only mode.

view() {
    if [ "$BATCAT" != "" ]; then
        batcat ${VIEWER_BATCAT_ARGS[*]} $@
    elif [ "$NANO" != "" ]; then
        nano ${VIEWER_NANO_ARGS[*]} $@
    else
        cat ${VIEWER_CAT_ARGS[*]} $@
    fi
}


# Preferred binary viewer, with fallbacks.
# We don't use VSCode because it doesn't currently support being launched in a read-only mode.
# We don't use nano because it doesn't support displaying non-printable characters.

viewb() {
    if [ "$BATCAT" != "" ]; then
        batcat ${VIEWERB_BATCAT_ARGS[*]} $@
    # We don't use nano to view binary files because it doesn't have an option to show all special characters.
    elif [ "$HEXDUMP" != "" ]; then
        hexdump ${VIEWERB_HEXDUMP_ARGS[*]} $@
    else
        cat ${VIEWERB_CAT_ARGS[*]} $@
    fi
}