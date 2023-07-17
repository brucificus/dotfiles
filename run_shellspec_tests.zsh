#!/usr/bin/env -S zsh --no-globalrcs --no-rcs


set -e
shellspec_bin="$(command -v shellspec)"
if [ ! $? ] || [ -z "$shellspec_bin" ]; then
    echo "Shellspec is not installed. Please install shellspec." >&2
    return 1
fi

shellspec --shell "$(realpath "./bin/zsh_pure")" --pattern "**/*.spec.zsh" "$@"
