#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if [ -z "$BASH_VERSION" ]; then return 0; fi
pushd "../../funcs" &> /dev/null || return 2
_assert_sourced "._bashit_load_core.bash" || source "._bashit_load_core.bash" || return $?
popd &> /dev/null || return 2
