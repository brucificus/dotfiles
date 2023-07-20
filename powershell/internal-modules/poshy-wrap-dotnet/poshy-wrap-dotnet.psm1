#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command dotnet)) {
    return
}

function dotnet-new {
    dotnet new @args
}
Set-Alias -Value dn -Name dotnet-new

function dotnet-run {
    dotnet run @args
}
Set-Alias -Value dr -Name dotnet-run

function dotnet-test {
    dotnet test @args
}
Set-Alias -Value dt -Name dotnet-test

function dotnet-watch {
    dotnet watch @args
}
Set-Alias -Value dw -Name dotnet-watch

function dotnet-watch-run {
    dotnet watch run @args

}
Set-Alias -Value dwr -Name dotnet-watch-run

function dotnet-watch-test {
    dotnet watch test @args
}
Set-Alias -Value dwt -Name dotnet-watch-test

function dotnet-sln {
    dotnet sln @args
}
Set-Alias -Value ds -Name dotnet-sln

function dotnet-add {
    dotnet add @args
}
Set-Alias -Value da -Name dotnet-add

function dotnet-pack {
    dotnet pack @args
}
Set-Alias -Value dp -Name dotnet-pack

function dotnet-nuget {
    dotnet nuget @args
}
Set-Alias -Value dng -Name dotnet-nuget

function dotnet-build {
    dotnet build @args
}
Set-Alias -Value db -Name dotnet-build

function dotnet-tool-list-global {
    dotnet tool list --global `
    | Select-Object -Skip 2 `
    | ForEach-Object { $_.Trim() -replace "\s+","`t" } `
    | ConvertFrom-Csv -Delimiter "`t" -Header "PackageId","Version","Commands"
}
Set-Alias -Value dtlg -Name dotnet-tool-list-global

function dotnet-tool-list-local {
    dotnet tool list --local `
    | Select-Object -Skip 2 `
    | ForEach-Object { $_.Trim() -replace "\s+","`t" } `
    | ConvertFrom-Csv -Delimiter "`t" -Header "PackageId","Version","Commands"
}
Set-Alias -Value dtll -Name dotnet-tool-list-local

function dotnet-tool-update-all-global {
    dotnet-tool-list-global `
    | ForEach-Object { dotnet tool update --global $_.PackageId }
}
Set-Alias -Value dtuag -Name dotnet-tool-update-all-global


Export-ModuleMember -Function * -Alias *
