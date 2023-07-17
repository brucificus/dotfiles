#!/usr/bin/env zsh
eval "$(shellspec - -c) exit 1"
# shellcheck shell=zsh


script_under_test="../../funcs/escape_regex"
Describe "funcs/escape_regex"

    ScriptUnderTestDir="$(realpath "$(dirname "$script_under_test")")"
    ScriptUnderTest="$(basename "$script_under_test")"

    # (Use this from tests that are unsure if a script can even just be sourced.)
    function cd_into_ScriptUnderTestDir() {
        cd "$ScriptUnderTestDir" || return $?
        source "$ScriptUnderTestDir/command_exists" &> /dev/null
        source "$ScriptUnderTestDir/find_binary" &> /dev/null
        source "$ScriptUnderTestDir/_has_glob" &> /dev/null
    }

    # Test(s) that the subject file doesn't have any major structural/syntax issues.
    Context "when sourced"
        BeforeEach 'cd_into_ScriptUnderTestDir'

        Parameters
            "escape_regex"
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

        Describe "function 'escape_regex', which"
            It "exists"
                When call type "escape_regex"

                The status should be success
                The output should include "$1 is a shell function"
            End

            Context "when given a string that contains no regex metacharacters"
                Parameters
                    "foo"
                    "bar"
                    "baz"
                End

                Example "returns the string unchanged"
                    When call escape_regex "$1"

                    The status should be success
                    The output should equal "$1"
                End
            End # Describe "when given a string that contains no regex metacharacters"

            local single_quote=$'\''
            local backslash=$'\\'

            Context "when given a string that contains a regex metacharacter"
                Parameters
                    "."
                    "*"
                    "?"
                    "("
                    ")"
                    "["
                    "]"
                    "{"
                    "}"
                    "^"
                    '$'
                    "|"
                    "+"
                End

                Example "returns the string with the regex metacharacter escaped"
                    When call escape_regex "$1"

                    The status should be success
                    The output should equal "$backslash$1"
                End
            End # Describe "when given a string that contains regex metacharacters"

            Context "when mode set for sed matcher patterns, and"
                Context "when given a string that contains no sed matcher metacharacters"
                    Parameters
                        "foo"
                        "bar"
                        "baz"
                    End

                    Example "returns the string unchanged"
                        When call escape_regex "$1" -sed_matcher_pattern

                        The status should be success
                        The output should equal "$1"
                    End
                End

                Context "when given a string that contains a sed matcher metacharacter"
                    Parameters
                        "."
                        "*"
                        "?"
                        "("
                        ")"
                        "["
                        "]"
                        "{"
                        "}"
                        "^"
                        '$'
                        "+"
                        "$single_quote"
                    End

                    Example "with no non-default delimiter specified, returns the string with the sed matcher metacharacter escaped"
                        When call escape_regex "$1" -sed_matcher_pattern

                        The status should be success
                        The output should equal "$backslash$1"
                    End
                End
            End # Context "when mode set for sed matcher patterns, and"

            Context "when mode set for sed replacement patterns, and"
                Context "when given a string that contains no sed replacement metacharacters"
                    Parameters
                        "foo"
                        "bar"
                        "baz"
                    End

                    Example "returns the string unchanged"
                        When call escape_regex "$1" -sed_replacement_pattern

                        The status should be success
                        The output should equal "$1"
                    End
                End

                Context "when given a string that contains a sed replacement metacharacter"
                    Parameters
                        '&'
                        "$single_quote"
                    End

                    Example "with no non-default delimiter specified, returns the string with the sed replacement metacharacter escaped"
                        When call escape_regex "$1" -sed_replacement_pattern

                        The status should be success
                        The output should equal "$backslash$1"
                    End
                End
            End # Context "when mode set for sed replacement patterns, and"
        End # Describe "function 'escape_regex'""

    End # Context "defines"
End
