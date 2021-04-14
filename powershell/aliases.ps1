# Update dotfiles
function dfu() {
    Set-Location ~/.dotfiles && git pull --ff-only && ./install.ps1 -q
    Set-Location ~/.dotfiles_local && git pull --ff-only && ./install.ps1 -q
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
    if (Get-Command "oh-my-posh" -ErrorAction SilentlyContinue) {
        Invoke-Expression (oh-my-posh --init --shell pwsh --config $themePath)
    } else {
        Set-PoshPrompt -Theme $themePath
    }
}
