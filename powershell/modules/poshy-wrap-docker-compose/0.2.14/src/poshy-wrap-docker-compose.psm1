#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command docker-compose) -and (-not (Get-Variable -Name PWSHRC_FORCE_MODULES_EXPORT_UNSUPPORTED -Scope Global -ValueOnly -ErrorAction SilentlyContinue))) {
    return
}

Set-Alias -Name dco -Value docker-compose

function Invoke-DockerComposeBuild {
    docker-compose build @args
}
Set-Alias -Name dcb -Value Invoke-DockerComposeBuild

function Invoke-DockerComposeExec {
    docker-compose exec @args
}
Set-Alias -Name dce -Value Invoke-DockerComposeExec

function Invoke-DockerComposePs {
    docker-compose ps @args
}
Set-Alias -Name dcps -Value Invoke-DockerComposePs

function Invoke-DockerComposeRestart {
    docker-compose restart @args
}
Set-Alias -Name dcrestart -Value Invoke-DockerComposeRestart

function Invoke-DockerComposeRm {
    docker-compose rm @args
}
Set-Alias -Name dcrm -Value Invoke-DockerComposeRm

function Invoke-DockerComposeRun {
    docker-compose run @args
}
Set-Alias -Name dcr -Value Invoke-DockerComposeRun

function Invoke-DockerComposeStop {
    docker-compose stop @args
}
Set-Alias -Name dcstop -Value Invoke-DockerComposeStop

function Invoke-DockerComposeUp {
    docker-compose up @args
}
Set-Alias -Name dcup -Value Invoke-DockerComposeUp

function Invoke-DockerComposeUpWithBuild {
    docker-compose up --build @args
}
Set-Alias -Name dcupb -Value Invoke-DockerComposeUpWithBuild

function Invoke-DockerComposeUpDetached {
    docker-compose up -d @args
}
Set-Alias -Name dcupd -Value Invoke-DockerComposeUpDetached

function Invoke-DockerComposeUpDetachedWithBuild {
    docker-compose up -d --build @args
}
Set-Alias -Name dcupbd -Value Invoke-DockerComposeUpDetachedWithBuild

function Invoke-DockerComposeDown {
    docker-compose down @args
}
Set-Alias -Name dcdn -Value Invoke-DockerComposeDown

function Invoke-DockerComposeLogs {
    docker-compose logs @args
}
Set-Alias -Name dcl -Value Invoke-DockerComposeLogs

function Invoke-DockerComposeLogsFollow {
    docker-compose logs -f @args
}
Set-Alias -Name dclf -Value Invoke-DockerComposeLogsFollow

function Invoke-DockerComposePull {
    docker-compose pull @args
}
Set-Alias -Name dcpull -Value Invoke-DockerComposePull

function Invoke-DockerComposeStart {
    docker-compose start @args
}
Set-Alias -Name dcstart -Value Invoke-DockerComposeStart

function Invoke-DockerComposeKill {
    docker-compose kill @args
}
Set-Alias -Name dck -Value Invoke-DockerComposeKill

<#
.SYNOPSIS
    Shut down, remove and start again the docker-compose setup, then tail the logs.
#>
function docker-compose-fresh() {
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [string] $dockerComposeYamlFile = $null
    )
    [string[]] $fileArgs = @()
    if ($dockerComposeYamlFile) {
        $fileArgs = @("--file", $dockerComposeYamlFile)
    }
    docker-compose @fileArgs stop
    docker-compose @fileArgs rm -f
    docker-compose @fileArgs up -d
    docker-compose @fileArgs logs -f --tail 100
}
Set-Alias -Name dcofresh -Value docker-compose-fresh

function Invoke-DockerComposeLogsFollowTail {
    docker-compose logs -f --tail 100 @args
}
Set-Alias -Name dcol -Value Invoke-DockerComposeLogsFollowTail

function Invoke-DockerComposeUp {
    docker-compose up @args
}
Set-Alias -Name dcou -Value Invoke-DockerComposeUp

function Invoke-DockerComposeUpNoStart {
    Invoke-DockerComposeUp --no-start @args
}
Set-Alias -Name dcouns -Value Invoke-DockerComposeUpNoStart


Export-ModuleMember -Function * -Alias *
