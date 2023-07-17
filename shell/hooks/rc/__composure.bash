# shellcheck source-path=SCRIPTDIR/../../funcs


composure_source="$(_concatenate_paths "${COMPOSURE:?}" "composure.sh")"
_assert_sourced "$composure_source" || {
    # shellcheck source=SCRIPTDIR/../../vendor/bash-it/vendor/github.com/erichs/composure/composure.sh
    source "$composure_source" || return $?

    # Support Bash-It's 'plumbing' metadata
    cite _about _param _example _group _author _version
    cite about-alias about-plugin about-completion
    unset composure_source
}
