#!/usr/bin/env bash
eval "$(shellspec - -c) exit 1"
# shellcheck shell=bash


script_under_test="../../../hooks/rc/_colors.bash"
Describe "hooks/rc/_colors.bash"

    ScriptUnderTestDir="$(realpath "$(dirname "$script_under_test")")"
    ScriptUnderTest="$(basename "$script_under_test")"

    # (Use this from tests that are unsure if a script can even just be sourced.)
    function cd_into_ScriptUnderTestDir() {
        cd "$ScriptUnderTestDir" || return $?

        about-plugin() { :; } # Mock out about-plugin.
        cite() { :; } # Mock out cite.
        Include "$ScriptUnderTestDir/../../funcs/_concatenate_paths"
        Include "$ScriptUnderTestDir/../../funcs/_log_info"
        Include "$ScriptUnderTestDir/../../funcs/_assert_sourced"
        Include "$ScriptUnderTestDir/../../funcs/._bashit_load_core.bash"
        BASH_IT="$ScriptUnderTestDir/../../vendor/bash-it"; export BASH_IT
        BASHIT_PLUGINS_AVAILABLE="${BASH_IT}/plugins/available"; export BASHIT_PLUGINS_AVAILABLE
    }

    # Test(s) that the subject file doesn't have any major structural/syntax issues.
    Context "when sourced"
        BeforeEach 'cd_into_ScriptUnderTestDir'

        It "succeeds"
            # This must use full path to script because, even though shellspec will run the script under the context
            # established by Before* test setups, it does not respect them when evaluating `When run source`.
            When run source "$ScriptUnderTestDir/$ScriptUnderTest"

            The status should be success
            The output should be blank
        End
    End

    # (Use this from tests that assume the subject file can be loaded without major problems.)
    function Include_ScriptUnderTest() {
        set -e
        cd_into_ScriptUnderTestDir
        Include "$ScriptUnderTest"
        set +e
    }

    # More detailed test(s) of the subject file's functionality.
    Context "defines"
        BeforeEach 'Include_ScriptUnderTest'

    End # Context "defines"
End
