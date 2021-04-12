#!/usr/bin/env pwsh

Param(
    [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            HelpMessage = 'A repository path.',
            Position = 0)]
    [string[]] $Path = $null,

    [Parameter(Position = 1, HelpMessage = 'Fetch all remotes.')]
    [switch] $All,

    [Parameter(Position = 2, HelpMessage = 'Skip automatic repository maintenance, including garbage collection.')]
    [switch] $NoAutoGC,

    [Parameter(Position = 3, HelpMessage = 'Before fetching, remove any remote-tracking references that no longer exist on the remote.')]
    [switch] $Prune,

    [Parameter(Position = 4, HelpMessage = 'Pass --quiet to git-fetch-pack and silence any other internally used git commands. Progress is not reported to the standard error stream.')]
    [switch] $Quiet

)

Begin {
    [string[]] $BaselineGitParameters = @("fetch")

    if ($All) {
        $BaselineGitParameters += @("--all")
    }

    if ($NoAutoGC) {
        $BaselineGitParameters += @("--no-auto-maintenance")
    }

    if ($Prune) {
        $BaselineGitParameters += @("--prune")
    }

    if ($Quiet) {
        $BaselineGitParameters += @("--quiet")
    }
}

Process {
    foreach ($pathItem in $Path) {
        [string[]] $gitParameters = $BaselineGitParameters

        pushd $pathItem
        try {
            git @gitParameters
        } finally {
            popd
        }
    }

}
