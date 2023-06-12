# Update dotfiles
function dfu() {
    Push-Location (Get-Item ~/.dotfiles).Target
    try {
        git pull --ff-only && ./install.ps1 -q
    } finally {
        Pop-Location
    }
}


Export-ModuleMember -Function dfu
