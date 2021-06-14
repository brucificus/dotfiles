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
