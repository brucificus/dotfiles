#!/usr/bin/env bash
eval "$(shellspec - -c) exit 1"
# shellcheck shell=bash


script_under_test="../../funcs/_normalize_path_pattern_pair"
Describe "funcs/_normalize_path_pattern_pair"

    ScriptUnderTestDir="$(realpath "$(dirname "$script_under_test")")"
    ScriptUnderTest="$(basename "$script_under_test")"

    # (Use this from tests that are unsure if a script can even just be sourced.)
    function cd_into_ScriptUnderTestDir() {
        cd "$ScriptUnderTestDir" || return $?
        Include "$ScriptUnderTestDir/_has_glob"
        Include "$ScriptUnderTestDir/_concatenate_paths"
        Include "$ScriptUnderTestDir/find_relative"
    }

    # Test(s) that the subject file doesn't have any major structural/syntax issues.
    Context "when sourced"
        BeforeEach 'cd_into_ScriptUnderTestDir'

        Parameters
            "_normalize_path_pattern_pair"
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

        Describe "function '_normalize_path_pattern_pair', which"
            It "exists"
                When call type "_normalize_path_pattern_pair"

                The status should be success
                The output should include "$1 is a function"
            End

            Context "when given a path and a non-globbed no-directory pattern"
                It "returns the path and the pattern separately as originally provided"
                    local target="path"
                    local pattern="not-pattern"
                    local expected_target="$target"
                    local expected_pattern="$pattern"
                    When call _normalize_path_pattern_pair "$target" "$pattern"

                    The status should be success
                    The line 1 of output should equal "$expected_target"
                    The line 2 of output should equal "$expected_pattern"
                End
            End # when given a path and a non-globbed no-directory pattern

            Context "when given a path and a globbed no-directory pattern"
                It "returns the path and the pattern separately as originally provided"
                    local target="path"
                    local pattern="*pattern*"
                    local expected_target="$target"
                    local expected_pattern="$pattern"
                    When call _normalize_path_pattern_pair "$target" "$pattern"

                    The status should be success
                    The line 1 of output should equal "$expected_target"
                    The line 2 of output should equal "$expected_pattern"
                End
            End # when given a path and a globbed no-directory pattern

            Context "when given a path and a non-globbed directory-divided pattern"
                It "returns the path with the directory part appended to the path but the remaining basename still in the the pattern"
                    local target="path"
                    local pattern="not-pattern-directory/not-pattern-basename"
                    local expected_target="$target/not-pattern-directory"
                    local expected_pattern="not-pattern-basename"
                    When call _normalize_path_pattern_pair "$target" "$pattern"

                    The status should be success
                    The line 1 of output should equal "$expected_target"
                    The line 2 of output should equal "$expected_pattern"
                End
            End # when given a path and a non-globbed directory-divided pattern

            Context "when given a path and a glob-prefixed directory-divded pattern"
                It "returns the path as provided and the pattern as provided"
                    local expected_target="path"
                    local expected_pattern="**/pattern"
                    When call _normalize_path_pattern_pair "$expected_target" "$expected_pattern"

                    The status should be success
                    The line 1 of output should equal "$expected_target"
                    The line 2 of output should equal "$expected_pattern"
                End
            End # when given a path and a glob-prefixed directory-divded pattern

            Context "when given a path and a glob-suffixed directory-divded pattern"
                It "returns the path with the directory part appended to the path but the remaining glob still in the pattern"
                    local target="path"
                    local pattern="not-pattern-directory/*patterned-basestem*"
                    local expected_target="$target/not-pattern-directory"
                    local expected_pattern="*patterned-basestem*"
                    When call _normalize_path_pattern_pair "$expected_target" "$expected_pattern"

                    The status should be success
                    The line 1 of output should equal "$expected_target"
                    The line 2 of output should equal "$expected_pattern"
                End
            End # when given a path and a glob-suffixed directory-divded pattern
        End # Describe "function '_normalize_path_pattern_pair'""

    End # Context "defines"
End
