$ErrorActionPreference = 'Stop'

Push-Location ~/.dotfiles/powershell

try {
    ./profile.ps1
} finally {
    Pop-Location
}

~/bin/Import-OptionallyExtantScriptOrModule.ps1 ~/.config/powershell/profile_local
