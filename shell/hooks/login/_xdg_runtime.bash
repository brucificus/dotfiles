#!/usr/bin/env bash


# Defines the base directory relative to which user-specific runtime files and other file
# objects should be stored. This directory is used to store volatile runtime files and
# other file objects (such as sockets, named pipes, ...), and should be cleaned out
# whenever the user logs out.


# See:
#     - https://unix.stackexchange.com/a/477049
# and - https://unix.stackexchange.com/a/580757

if [ -z "$XDG_RUNTIME_DIR" ]; then
    if [ ! -d "/run/user/$UID" ]; then
        # If systemd didn't make a directory for us, we'll use /tmp
        XDG_RUNTIME_DIR="/tmp/$USER-runtime"; export XDG_RUNTIME_DIR

        if [ ! -d "$XDG_RUNTIME_DIR" ]; then # Doesn't already exist
            mkdir -m 0700 "$XDG_RUNTIME_DIR"
        fi
    else
        XDG_RUNTIME_DIR="/run/user/$UID"; export XDG_RUNTIME_DIR
    fi
fi

# Check dir has got the correct type, ownership, and permissions.
if ! [[ -d "$XDG_RUNTIME_DIR" && -O "$XDG_RUNTIME_DIR" &&
    "$(stat -c '%a' "$XDG_RUNTIME_DIR")" = 700 ]]; then
    append_profile_suggestions "# TODO: ⚠️ Fix permissions problem with: $XDG_RUNTIME_DIR"
    XDG_RUNTIME_DIR="$(mktemp -d /tmp/"$USER"-runtime-XXXXXX)"; export XDG_RUNTIME_DIR
fi
