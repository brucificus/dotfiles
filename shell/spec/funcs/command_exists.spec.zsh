#!/usr/bin/env zsh
eval "$(shellspec - -c) exit 1"
# shellcheck shell=zsh


script_under_test="../../funcs/command_exists"
Describe "funcs/command_exists"

    ScriptUnderTestDir="$(realpath "$(dirname "$script_under_test")")"
    ScriptUnderTest="$(basename "$script_under_test")"

    # (Use this from tests that are unsure if a script can even just be sourced.)
    function cd_into_ScriptUnderTestDir() {
        cd "$ScriptUnderTestDir" || return $?
        : # TODO: 🔧 source those dependencies.
    }

    # Test(s) that the subject file doesn't have any major structural/syntax issues.
    Context "when sourced"
        BeforeEach 'cd_into_ScriptUnderTestDir'

        Parameters
            "command_exists"
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
    function source_ScriptUnderTest() {
        set -e
        cd_into_ScriptUnderTestDir
        source "$ScriptUnderTest" &> /dev/null
        set +e
    }

    # More detailed test(s) of the subject file's functionality.
    Context "defines"
        BeforeEach 'source_ScriptUnderTest'

        Describe "function 'command_exists', which"
            It "exists"
                When call type "command_exists"

                The status should be success
                The output should include "$1 is a shell function"
            End
        End # Describe "function 'command_exists'""

    End # Context "defines"
End
