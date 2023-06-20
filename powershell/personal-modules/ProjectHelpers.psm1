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

function New-VisualStudioSolution {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName="FilePath", Position=0)]
        [string] $FilePath
    )
    Begin {
        [string] $extension = [System.IO.Path]::GetExtension($FilePath)
        if ($extension -ne ".sln") {
            $FilePath = $FilePath + ".sln"
        }

        if ([string]::IsNullOrWhiteSpace($LiteralPath)) {
            $LiteralPath = $PWD.Path
        }
    }
    Process {
        [string] $content = "
Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio Version 17
VisualStudioVersion = 17.0.32112.339
MinimumVisualStudioVersion = 10.0.40219.1
Global
`tGlobalSection(SolutionProperties) = preSolution
`t`tHideSolutionNode = FALSE
`tEndGlobalSection
`tGlobalSection(ExtensibilityGlobals) = postSolution
`t`tSolutionGuid = {$((new-guid).ToString().ToUpper())}
`tEndGlobalSection
EndGlobal
".Trim()
        $content | Out-File -FilePath $FilePath -NoNewline
    }
}


Export-ModuleMember -Function "Format-GitRepository"
Export-ModuleMember -Function "New-VisualStudioSolution"