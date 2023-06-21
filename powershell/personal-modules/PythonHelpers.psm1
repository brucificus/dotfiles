Set-EnvVar -Process -Name PIP_REQUIRE_VIRTUALENV -Value "true"


if (Get-Command pip -ErrorAction SilentlyContinue) {
    # Explicitly use the system-wide pip (without requiring a virtualenv).
    function syspip() {
        $PIP_REQUIRE_VIRTUALENV = $Env:PIP_REQUIRE_VIRTUALENV
        $Env:PIP_REQUIRE_VIRTUALENV = "false"
        try {
            pip $args
        } finally {
            $Env:PIP_REQUIRE_VIRTUALENV = $PIP_REQUIRE_VIRTUALENV
        }
    }
    Export-ModuleMember -Function syspip
}

if (Get-Command pip2 -ErrorAction SilentlyContinue) {
    # Explicitly use the system-wide pip2 (without requiring a virtualenv).
    function syspip2() {
        $PIP_REQUIRE_VIRTUALENV = $Env:PIP_REQUIRE_VIRTUALENV
        $Env:PIP_REQUIRE_VIRTUALENV = "false"
        try {
            pip2 $args
        } finally {
            $Env:PIP_REQUIRE_VIRTUALENV = $PIP_REQUIRE_VIRTUALENV
        }
    }
    Export-ModuleMember -Function syspip2
}

if (Get-Command pip3 -ErrorAction SilentlyContinue) {
    # Explicitly use the system-wide pip3 (without requiring a virtualenv).
    function syspip3() {
        $PIP_REQUIRE_VIRTUALENV = $Env:PIP_REQUIRE_VIRTUALENV
        $Env:PIP_REQUIRE_VIRTUALENV = "false"
        try {
            pip3 $args
        } finally {
            $Env:PIP_REQUIRE_VIRTUALENV = $PIP_REQUIRE_VIRTUALENV
        }
    }
    Export-ModuleMember -Function syspip3
}
