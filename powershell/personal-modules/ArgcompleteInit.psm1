
# This is a helper layered on top of the `argcomplete` support for PowerShell.
# For more information about PowerShell support in `argcomplete`, see: https://github.com/kislyuk/argcomplete/tree/develop/contrib#powershell-support

if (-not $Env:PYTHON3) {
    break
}

function python3() {
    & $Env:PYTHON3 @args
}

$argcompleteRegisterCommand = Get-Command register-python-argcomplete -ErrorAction SilentlyContinue

if ($argcompleteRegisterCommand) {
    [string] $argcompleteRegister = $argcompleteRegisterCommand.Source
    function Register-ArgcompleteArgumentCompleter {
        param(
            [Parameter(Mandatory = $true)]
            [string] $CommandName
        )
        python3 $argcompleteRegister --shell powershell $CommandName | Out-String | Invoke-Expression
    }
    Export-ModuleMember -Function Register-ArgcompleteArgumentCompleter

    [string[]] $argcompletePrograms = Get-Content -Path "$PSScriptRoot/../../config/argcomplete/compat_programs.txt"
    foreach ($program in $argcompletePrograms) {
        if (Get-Command $program -ErrorAction SilentlyContinue) {
            Register-ArgcompleteArgumentCompleter $program
        }
    }
}
