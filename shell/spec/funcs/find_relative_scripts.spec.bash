#!/usr/bin/env bash
eval "$(shellspec - -c) exit 1"
# shellcheck shell=bash


script_under_test="../../funcs/find_relative_scripts"
Describe "funcs/find_relative_scripts"

    ScriptUnderTestDir="$(realpath "$(dirname "$script_under_test")")"
    ScriptUnderTest="$(basename "$script_under_test")"

    # (Use this from tests that are unsure if a script can even just be sourced.)
    function cd_into_ScriptUnderTestDir() {
        cd "$ScriptUnderTestDir" || return $?
        Include "$ScriptUnderTestDir/_has_glob"
        Include "$ScriptUnderTestDir/_concatenate_paths"
        Include "$ScriptUnderTestDir/_normalize_path_pattern_pair"
        Include "$ScriptUnderTestDir/find_relative"
        Include "$ScriptUnderTestDir/command_exists"
        Include "$ScriptUnderTestDir/find_binary"
    }

    # Test(s) that the subject file doesn't have any major structural/syntax issues.
    Context "when sourced"
        BeforeEach 'cd_into_ScriptUnderTestDir'

        Parameters
            "find_relative_scripts"
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

        Describe "function 'find_relative_scripts', which"
            It "exists"
                When call type "find_relative_scripts"

                The status should be success
                The output should include "$1 is a function"
            End

            Context "when given an ancestor-relative pattern of known script files"
                Context "and is given a newline-based print action"
                    It "prints the relative paths of the matching files"
                        When call find_relative_scripts "../funcs/*" "-print"

                        The status should be success
                        The output should include "../funcs/_normalize_path_pattern_pair"
                    End
                End # Context "and is given a newline-based print action"
            End # Context "when given an ancestor-relative pattern of known script files"
        End # Describe "function 'find_relative_scripts'""

    End # Context "defines"
End
