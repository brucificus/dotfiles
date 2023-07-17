#!/usr/bin/env bash


#
# Find binaries for specialized viewers.
#
HEXDUMP="$(find_binary "hexdump")" || HEXDUMP=''
if [ -z "$HEXDUMP" ]; then
    append_profile_suggestions "# TODO: 🔢 Add \`hexdump\` to your PATH."
    unset HEXDUMP;
else export HEXDUMP; fi

BATCAT="$(find_binary "batcat")" || BATCAT=''
if [ -z "$BATCAT" ]; then BATCAT="$(find_binary "bat")" || BATCAT=''; fi
if [ -z "$BATCAT" ]; then
    append_profile_suggestions "# TODO: 🦇🐈 Add \`batcat\` to your PATH."
    unset BATCAT;
else export BATCAT; fi


#
# Setup parameters for viewers.
#
if [ -n "$BATCAT" ]; then
    BAT_THEME="ansi-dark"; export BAT_THEME
    VIEWER_BATCAT_ARGS=(); export VIEWER_BATCAT_ARGS
    VIEWERB_BATCAT_ARGS=("${VIEWER_BATCAT_ARGS[*]}""--show-all"); export VIEWERB_BATCAT_ARGS
fi

if [ -n "$NANO" ]; then
    if [ -n "${EDITOR_NANO_ARGS[*]}" ]; then
        VIEWER_NANO_ARGS=("${EDITOR_NANO_ARGS[@]}")
    else
        VIEWER_NANO_ARGS=()
    fi
    VIEWER_NANO_ARGS+=(--view)

    VIEWER_CAT_ARGS=(--number)
    VIEWERB_CAT_ARGS=("${VIEWER_CAT_ARGS[*]}""--show-all")
fi


#
# Decide on a viewer.
#
# We don't use VSCode because it doesn't currently support being launched in a read-only mode.
if [ -n "$BATCAT" ]; then
    if [ -n "${VIEWER_BATCAT_ARGS[*]}" ]; then
        VIEWER="$BATCAT ${VIEWER_BATCAT_ARGS[*]}"
    else
        VIEWER="$BATCAT"
    fi
elif [ -n "$NANO" ]; then
    if [ -n "${VIEWER_NANO_ARGS[*]}" ]; then
        VIEWER="$NANO ${VIEWER_NANO_ARGS[*]}"
    else
        VIEWER="$NANO"
    fi
else
    if [ -n "${VIEWER_CAT_ARGS[*]}" ]; then
        VIEWER="cat ${VIEWER_CAT_ARGS[*]}"
    else
        VIEWER="cat"
    fi
fi
if [ -n "$VIEWER" ]; then
    export VIEWER
else
    unset VIEWER
fi


#
# Decide on a binary viewer.
#
# We don't use VSCode because it doesn't currently support being launched in a read-only mode.
# We don't use nano for binary files because it doesn't support displaying non-printable characters.
if [ -n "$BATCAT" ]; then
    if [ -n "${VIEWERB_BATCAT_ARGS[*]}" ]; then
        VIEWERB="$BATCAT ${VIEWERB_BATCAT_ARGS[*]}"
    else
        VIEWERB="$BATCAT"
    fi
elif [ -n "$HEXDUMP" ]; then
    if [ -n "${VIEWERB_HEXDUMP_ARGS[*]}" ]; then
        VIEWERB="$HEXDUMP ${VIEWERB_HEXDUMP_ARGS[*]}"
    else
        VIEWERB="$HEXDUMP"
    fi
else
    if [ -n "${VIEWERB_CAT_ARGS[*]}" ]; then
        VIEWERB="cat ${VIEWERB_CAT_ARGS[*]}"
    else
        VIEWERB="cat"
    fi
fi
if [ -n "$VIEWERB" ]; then
    export VIEWERB
fi
