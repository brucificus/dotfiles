#!/usr/bin/env -S bash --noprofile --norc


set -e
shellspec_bin="$(command -v shellspec)"
if [ ! $? ] || [ -z "$shellspec_bin" ]; then
    echo "Shellspec is not installed. Please install shellspec." >&2
    return 1
fi

shellspec --shell "$(realpath "./bin/bash_pure")" --pattern "**/*.spec.bash" "$@"
