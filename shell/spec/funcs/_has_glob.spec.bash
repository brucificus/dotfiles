#!/usr/bin/env bash
eval "$(shellspec - -c) exit 1"
# shellcheck shell=bash


script_under_test="../../funcs/_has_glob"
Describe "funcs/_has_glob"

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
            "_has_glob"
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

        Describe "function '_has_glob', which"
            It "exists"
                When call type "_has_glob"

                The status should be success
                The output should include "$1 is a function"
            End

            Context ", when passed a glob"
                It "returns success"
                    When call _has_glob "*"

                    The status should be success
                End
            End # Context "passed a glob"

            Context ", when passed a non-glob"
                It "returns failure"
                    When call _has_glob "not-a-glob"

                    The status should be failure
                End
            End # Context "passed a non-glob"

            Context ", when passed a double-star glob"
                It "returns success"
                    When call _has_glob "**"

                    The status should be success
                End
            End # Context "passed a double-star glob"

            Context ", when passed a glob with a character class"
                It "returns success"
                    When call _has_glob "[a-z]"

                    The status should be success
                End
            End # Context "passed a glob with a character class"

            Context ", when passed a glob with a question mark"
                It "returns success"
                    When call _has_glob "?"

                    The status should be success
                End
            End # Context "passed a glob with a question mark"

            Context ", when passed a glob with a square bracket"
                It "returns success"
                    When call _has_glob "[]"

                    The status should be success
                End
            End # Context "passed a glob with a square bracket"

            Context ", when passed a glob star pattern with a directory"
                It "returns success"
                    When call _has_glob "*/"

                    The status should be success
                End
            End # Context "passed a glob star pattern with a directory"

            Context ", when passed a double-star glob pattern with a directory"
                It "returns success"
                    When call _has_glob "**/"

                    The status should be success
                End
            End # Context "passed a double-star glob star pattern with a directory"
        End # Describe "function '_has_glob'""
    End # Context "defines"
End
