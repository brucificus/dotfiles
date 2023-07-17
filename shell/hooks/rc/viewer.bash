#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Preferred viwers & binary viewers, with fallbacks, varying based on session context.


# Some convenience for bat/batcat.
if ! command_exists "bat" && command_exists "batcat"; then
    alias bat="batcat"
elif command_exists "bat" && ! command_exists "batcat"; then
    alias batcat="bat"
fi


# view()
# We don't use VSCode because it doesn't currently support being launched in a read-only mode.
if [ -n "$BATCAT" ]; then
    if [ -n "${VIEWER_BATCAT_ARGS[*]}" ]; then
        view() {
            $BATCAT ${VIEWER_BATCAT_ARGS[*]} "$@"
        }
    else
        view() {
            $BATCAT "$@"
        }
    fi

    export MANPAGER="sh -c 'col -bx | "$BATCAT" -l man -p'"
elif [ -n "$NANO" ]; then
    if [ -n "${VIEWER_NANO_ARGS[*]}" ]; then
        view() {
            $NANO ${VIEWER_NANO_ARGS[*]} "$@"
        }
    else
        view() {
            $NANO "$@"
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
if [ -n "$VIEWER" ]; then
    export VIEWER
fi


# viewb()
# We don't use VSCode because it doesn't currently support being launched in a read-only mode.
# We don't use nano because it doesn't support displaying non-printable characters.
if [ -n "$BATCAT" ]; then
    if [ -n "${VIEWERB_BATCAT_ARGS[*]}" ]; then
        viewb() {
            $BATCAT ${VIEWERB_BATCAT_ARGS[*]} "$@"
        }
    else
        viewb() {
            $BATCAT "$@"
        }
    fi
# We don't use nano to view binary files because it doesn't have an option to show all special characters.
elif [ -n "$HEXDUMP" ]; then
    if [ -n "${VIEWERB_HEXDUMP_ARGS[*]}" ]; then
        viewb() {
            $HEXDUMP ${VIEWERB_HEXDUMP_ARGS[*]} "$@"
        }
    else
        viewb() {
            $HEXDUMP "$@"
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


# Mirror stdout to stderr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'

if binary_exists grep; then
    # Check if a file contains non-ascii characters
    nonascii() {
        LC_ALL=C grep -n '[^[:print:][:space:]]' "${1}"
    }
fi
