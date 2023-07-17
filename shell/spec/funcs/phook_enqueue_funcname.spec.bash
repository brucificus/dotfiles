#!/usr/bin/env bash
eval "$(shellspec - -c) exit 1"
# shellcheck shell=bash


script_under_test="../../funcs/phook_enqueue_funcname"
Describe "funcs/phook_enqueue_funcname"

    ScriptUnderTestDir="$(realpath "$(dirname "$script_under_test")")"
    ScriptUnderTest="$(basename "$script_under_test")"

    # (Use this from tests that are unsure if a script can even just be sourced.)
    function cd_into_ScriptUnderTestDir() {
        cd "$ScriptUnderTestDir" || return $?
        : # TODO: 🔧 Include those dependencies.
    }

    # Test(s) that the subject file doesn't have any major structural/syntax issues.
    Context "when sourced"
        BeforeEach 'cd_into_ScriptUnderTestDir'

        Parameters
            "phook_enqueue_funcname"
        End

        Example "$1"
            # This must use full path to script because, even though shellspec will run the script under the context
            # established by Before* test setups, it does not respect them when evaluating `When run source`.
            When run source "$ScriptUnderTestDir/$ScriptUnderTest"

            The status should be success
            The output should be blank
            The function "$1" should be defined
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

        Describe "function 'phook_enqueue_funcname', which"
            It "exists"
                When call type "phook_enqueue_funcname"

                The status should be success
                The output should include "$1 is a function"
            End
        End # Describe "function 'phook_enqueue_funcname'""

    End # Context "defines"
End
