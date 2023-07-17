#!/usr/bin/env bash


# shellcheck disable=SC1090  # Dynamic source.
# shellcheck disable=SC2015  # We don't care about the exit code of this.
[ "$TERM_PROGRAM" = "vscode" ] && . "$(code --locate-shell-integration-path "$(shell_actual)")" || true
