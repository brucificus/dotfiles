#!/usr/bin/env bash


# If we're running in MINGW (e.g. Git Bash)…
if [[ "$OSTYPE" = "msys" ]]; then
    # …and if 'activate-global-python-argcomplete' is installed…
    # See: https://github.com/kislyuk/argcomplete
    if which activate-global-python-argcomplete > /dev/null; then
        # …set the variable telling argcomplete to be compatible.
        # See: https://github.com/kislyuk/argcomplete/tree/develop/contrib#git-bash-support
        export ARGCOMPLETE_USE_TEMPFILES=1
    fi
fi
