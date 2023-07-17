#!/usr/bin/env sh


set -e
shellspec_bin="$(command -v shellspec)"
if [ ! $? ] || [ -z "$shellspec_bin" ]; then
    echo "Shellspec is not installed. Please install shellspec." >&2
    return 1
fi

shellspec --shell sh --pattern "**/*.spec.sh" "$@"
