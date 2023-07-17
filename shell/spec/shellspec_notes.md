'When call' <function>
    - No subshell.
    - Likely supports code coverage.
    - CAN call functions.

    - ❌ Arg <function> as <filename> does NOT work (i.e. for sourcing). (Isn't a function.) ("command not found")
    for whether or not a `cd <path>` in BeforeEach is respected:
        - …


'When run' <command>
    - Subshell.
    - Does NOT support code coverage.
    - Does not have to "be a shell script." (So functions are probably allowed?)

    - ❌ Arg <command> as <filename> does NOT work (i.e. for sourcing). ("command not found")
    for whether or not a `cd <path>` in BeforeEach is respected:
        - …


'When run command' <command>
    - Subshell (see above.)
    - Does NOT support code coverage. (see above.)
    - Can NOT call a "shell function".
    - Argument doesn't *have* to be a shell script. (i.e. can call binaries)
    - Respects the shebang of the target, if there is one.

    - ❌ Arg <command> as 'type' does NOT work. (Is a "shell function"?)
    for whether or not a `cd <path>` in earliest BeforeEach is respected:
        - ✖️❔ Unclear if file is allowable as arg. Message was "<file>: not found".


'When run script' <script>
    - Another (parallel?) instance of the current shell.
    - Code coverage support unclear. (see above?)
    - Argument MUST be a shell script.
    - Does NOT respect the shebang of the target.
    - Function-based mocking is NOT available.


    for whether or not a `cd <path>` in earliest BeforeEach is respected:
        - ❌ "<file>: No such file or directory"


'When run source' <script>
    - Sources a script. (MUST be a script.)
    - Code coverage support unclear. (see above?)
    - Argument MUST be a shell script.
    - Does NOT respect the shebang of the target.
    - Function-based mocking IS available.


    for whether or not a `cd <path>` in earliest BeforeEach is respected:
        - ❌ "<file>: No such file or directory"



Can use `Include "$ScriptUnderTest"` sometimes.
Seems to just be for support code, though.

Include seems to run BEFORE any/all BeforeEach's. (Unless in them, I guess, but I don't think that's possible.)
i.e. ❌ Does NOT respect a `cd <path>` in BeforeEach. "<file>: No such file or directory"



❌: naked 'run' (in a BeforeEach hook) isn't a valid keyword, irrespective of if it is followed by 'script' or 'source'.
❌: "Include cannot be defined inside of Example"
