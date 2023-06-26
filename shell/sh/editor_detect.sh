# shellcheck shell=sh

# Preferred editors & viewers, with fallbacks, varying based on session context.

if [ -n "$(command -v edit)" ] && [ -n "$(command -v view)" ] && [ -n "$(command -v viewb)" ]; then
    return
fi


#
# $EDITOR and edit()
#

if [ -n "$(command -v whence)"  ]; then
    VSCODE="$(whence code)"
    NANO="$(whence nano)"
    NEOVIM="$(whence nvim)"
    VIM="$(whence vim)"
    VI="$(whence vi)"
    HEXDUMP="$(whence hexdump)"
else
    VSCODE="$(which code)"
    NANO="$(which nano)"
    NEOVIM="$(which nvim)"
    VIM="$(which vim)"
    VI="$(which vi)"
    HEXDUMP="$(which hexdump)"
fi

NANO_HELP="$(nano -h)"
NANO_ARGS=(--stateflags --linenumbers --noconvert --minibar --magic --positionlog --indicator)
for i in "${NANO_ARGS[@]}"
do
    NANO_HAS_PARAM=$(echo "$NANO_HELP" | grep -e "$i" -)
    if [ -z "$NANO_HAS_PARAM" ]; then
        NANO_ARGS=( "${NANO_ARGS[@]/$i}" )
    fi
done
if [ -n "$NANO" ] && [ -n "$SSH_CONNECTION" ]; then
    # If nano exists and we aren't in an SSH connection, let's try to use a mouse.
    NANO_ARGS+=("--mouse")
fi

if [ -n "$VSCODE" ] && [ -n "$VSCODE_IPC_HOOK_CLI" ]; then
    # If we are in VSCode's embedded terminal, let's try to reuse the window.
    VSCODE_ARGS=(--reuse-window --wait)
elif [ -n "$VSCODE" ]; then
    # If we are NOT in VSCode's embedded terminal, let's always open a new window.
    VSCODE_ARGS=(--new-window --wait)
fi

if [ -n "$VSCODE" ] && [ -n "$SSH_CONNECTION" ]; then
    EDITOR="code ${VSCODE_ARGS[*]}"
    edit() {
        code ${VSCODE_ARGS[*]} "$@"
    }
elif [ -n "$NANO" ]; then
    # If nano exists, let's use it.
    # We don't pass in $NANO_ARGS because we've included it in the alias above.
    EDITOR="nano"
    edit() {
        nano ${NANO_ARGS[*]} "$@"
    }
elif [ -n "$NEOVIM" ]; then
    # If neovim exists, let's use it.
    EDITOR="nvim"
    edit() {
        nvim "$@"
    }
elif [ -n "$VIM" ]; then
    # If vim exists, let's use it.
    EDITOR="vim"
    edit() {
        vim "$@"
    }
elif [ -n "$VI" ]; then
    # If vi exists, let's use it.
    EDITOR="vi"
    edit() {
        vi "$@"
    }
elif [ -n "$EDITOR" ]; then
    # If $EDITOR is set, let's use it.
    edit() {
        "$EDITOR" "$@"
    }
else
    # Fallback to something every system probably has.
    EDITOR="ed"
    edit() {
        ed "$@"
    }
fi
if [ -n "$EDITOR" ]; then
    export EDITOR
fi


#
# Prepare to setup viewers.
#
BAT_THEME="ansi-dark"; export BAT_THEME
BATCAT="$(which batcat)"
if [ -z "$BATCAT" ]; then
    BATCAT="$(which bat)"
    if [ -z "$BATCAT" ]; then
        alias batcat="bat"
    fi
else
    alias bat="batcat"
fi

VIEWER_BATCAT_ARGS=()
VIEWERB_BATCAT_ARGS=("${VIEWER_BATCAT_ARGS[*]}""--show-all")

VIEWER_NANO_ARGS=(--view)

VIEWER_CAT_ARGS=(--number)
VIEWERB_CAT_ARGS=("${VIEWER_CAT_ARGS[*]}""--show-all")



#
# view()
#

# We don't use VSCode because it doesn't currently support being launched in a read-only mode.
if [ -n "$BATCAT" ]; then
    if [ -n "${VIEWER_BATCAT_ARGS[*]}" ]; then
        view() {
            batcat ${VIEWER_BATCAT_ARGS[*]} "$@"
        }
    else
        view() {
            batcat "$@"
        }
    fi
elif [ -n "$NANO" ]; then
    if [ -n "${VIEWER_NANO_ARGS[*]}" ]; then
        view() {
            nano ${VIEWER_NANO_ARGS[*]} "$@"
        }
    else
        view() {
            nano "$@"
        }
    fi
else
    if [ -n "${VIEWER_CAT_ARGS[*]}" ]; then
        view() {
            cat ${VIEWER_CAT_ARGS[*]} "$@"
        }
    else
        view() {
            cat "$@"
        }
    fi
fi


#
# viewb()
#

# We don't use VSCode because it doesn't currently support being launched in a read-only mode.
# We don't use nano because it doesn't support displaying non-printable characters.
if [ -n "$BATCAT" ]; then
    if [ -n "${VIEWERB_BATCAT_ARGS[*]}" ]; then
        viewb() {
            batcat ${VIEWERB_BATCAT_ARGS[*]} "$@"
        }
    else
        viewb() {
            batcat "$@"
        }
    fi
# We don't use nano to view binary files because it doesn't have an option to show all special characters.
elif [ -n "$HEXDUMP" ]; then
    if [ -n "${VIEWERB_HEXDUMP_ARGS[*]}" ]; then
        viewb() {
            hexdump ${VIEWERB_HEXDUMP_ARGS[*]} "$@"
        }
    else
        viewb() {
            hexdump "$@"
        }
    fi
else
    if [ -n "${VIEWERB_CAT_ARGS[*]}" ]; then
        viewb() {
            cat ${VIEWERB_CAT_ARGS[*]} "$@"
        }
    else
        viewb() {
            cat "$@"
        }
    fi
fi
