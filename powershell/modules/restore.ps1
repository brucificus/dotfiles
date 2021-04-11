if (-not (Get-Command "nuget" -ErrorAction SilentlyContinue)) {
    throw "NuGet executable not found."
}

if (Test-Path "$PSScriptRoot\..\.trash" -ErrorAction SilentlyContinue) {
    Remove-Item "$PSScriptRoot\..\.trash" -Recurse -Force | Out-Null
}

Push-Location "$PSScriptRoot"

try {
    nuget restore

    Get-ChildItem -Path $PSScriptRoot -Filter ".git" -Directory -Recurse | Remove-Item -Recurse -Force | Out-Null
}
finally {
    Pop-Location
}