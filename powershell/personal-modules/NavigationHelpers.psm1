# cd to git root directory
function cdgr() {
    Set-Location $(git root)
}

# Create a directory and cd into it
function mcd([string] $location) {
    mkdir $location | Set-Location
}


Export-ModuleMember -Function "cdgr"
Export-ModuleMember -Function "mcd"
