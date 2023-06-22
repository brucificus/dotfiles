Set-EnvVar -Process -Name PIP_REQUIRE_VIRTUALENV -Value "true"

# If we are in WSL, make sure we don't use the Windows python3/pip3.
if ($Env:WSL_DISTRO_NAME) {
    Remove-EnvPathItem -Process -ValueMatch "^/mnt/.*Python.*/Scripts"
}

if (-not $Env:PYTHON3) {
    # Find the python3 executable, make sure it isn't the Windows one from within WSL.
    $PYTHON3 = (Get-Command python3 -ErrorAction SilentlyContinue).Source
    if ($PYTHON3 -and $PYTHON3 -notlike "/mnt/*") {
        Set-EnvVar -Process -Name PYTHON3 -Value $PYTHON3
    } else {
        Remove-Variable -Name PYTHON3 -ErrorAction SilentlyContinue
    }
    if (-not $Env:PYTHON3) {
        break
    }
}

if (-not $Env:PIP3) {
    # Find the pip3 executable, make sure it isn't the Windows one from within WSL.
    $PIP3 = (Get-Command pip3 -ErrorAction SilentlyContinue).Source
    if ($PIP3 -and $PIP3 -notlike "/mnt/*") {
        Set-EnvVar -Process -Name PIP3 -Value $PIP3
    } else {
        Remove-Variable -Name PIP3 -ErrorAction SilentlyContinue
    }
    if (-not $Env:PIP3) {
        break
    }
}

# Explicitly use the system-wide pip3 (without requiring a virtualenv).
function syspip3() {
    $PIP_REQUIRE_VIRTUALENV = $Env:PIP_REQUIRE_VIRTUALENV
    Set-EnvVar -Process -Name PIP_REQUIRE_VIRTUALENV -Value "false"
    try {
        pip3 $args
    } finally {
        Set-EnvVar -Process -Name PIP_REQUIRE_VIRTUALENV -Value $PIP_REQUIRE_VIRTUALENV
    }
}
Export-ModuleMember -Function syspip3

# pip should only run if there is a virtualenv currently activated
Set-EnvVar -Process -Name PIP_REQUIRE_VIRTUALENV -Value "true"

# Cache pip-installed packages to avoid re-downloading
Set-EnvVar -Process -Name PIP_DOWNLOAD_CACHE -Value (Join-Path $Env:HOME ".pip/cache")

# Python startup file
Set-EnvVar -Process -Name PYTHONSTARTUP -Value (Join-Path $Env:HOME ".pythonrc")
