# Update dotfiles
function dfu() {
    Push-Location (Get-Item ~/.dotfiles).Target
    try {
        git pull --ff-only && ./install.ps1 -q
    } finally {
        Pop-Location
    }
}

# cd to git root directory
function cdgr() {
    Set-Location $(git root)
}

# Create a directory and cd into it
function mcd([string] $location) {
    mkdir $location | Set-Location
}

function Set-PoshPromptPortably([string] $themePath) {
    if ($IsLinux -and (Get-Command "oh-my-posh-wsl" -ErrorAction SilentlyContinue)) {
        Invoke-Expression (oh-my-posh-wsl --init --shell pwsh --config $themePath)
    }
    elseif (Get-Command "oh-my-posh" -ErrorAction SilentlyContinue) {
        Invoke-Expression (oh-my-posh --init --shell pwsh --config $themePath)
    } else {
        Set-PoshPrompt -Theme $themePath
    }
}

function Expand-Property {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [PSObject[]] $inputObjects,
        [Parameter(Mandatory = $true, Position = 0)] [string[]] $propertyChain
    )

    [PSObject[]] $results = $inputObjects
    foreach($property in $propertyChain) {
        $results = $results | Select-Object -ExpandProperty $property
    }

    return $results
}

function Format-GitRepository {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string] $LiteralPath
    )
    Begin {
        if ([string]::IsNullOrWhiteSpace($LiteralPath)) {
            $LiteralPath = $PWD.Path
        }
    }
    Process {
        Push-Location -LiteralPath $LiteralPath
        try {
            [bool] $likelyHasInitialCommit = $false
            if (-not (Get-ChildItem -Filter .git -Hidden)) {
                git init --quiet
                if (-not $?) {
                    Write-Error "Failure to 'git init'"
                    return
                }
                $likelyHasInitialCommit = $false
            } else {
                git log 2>&1 | Out-Null
                $likelyHasInitialCommit = $?
            }

            [string] $porcelainGitStatus = git status --porcelain
            if (-not [string]::IsNullOrWhiteSpace($porcelainGitStatus)) {
                Write-Error "Unexpected content in 'git status'"
                return
            }

            if (-not $likelyHasInitialCommit) {
                [string] $epoch = "01 Jan 1970 00:00:00 +0000"
                $Env:GIT_AUTHOR_DATE = $epoch
                $Env:GIT_COMMITTER_DATE = $epoch
                git commit --message="🎉 Initial Commit" --allow-empty --no-edit --quiet 2>&1 | Out-Null
                if (-not $?) {
                    Write-Error "Failure to 'git commit --message=`"🎉 Initial Commit`" --allow-empty'"
                    return
                }
            }
        } finally {
            Pop-Location
        }
    }
}
