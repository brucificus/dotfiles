function Get-ChildItemPersonalized() {
    return Get-ChildItem -Hidden -System @args | Sort-Object -Property @{Expression = { $_.PSIsContainer }}, @{Expression = { $_.Name }}
}
Set-Alias -Name "ls" -Value Get-ChildItemPersonalized
Set-Alias -Name "ll" -Value Get-ChildItemPersonalized
Set-Alias -Name "la" -Value Get-ChildItemPersonalized
Set-Alias -Name "l" -Value Get-ChildItemPersonalized
Set-Alias -Option AllScope -Name "dir" -Value Get-ChildItemPersonalized
Export-ModuleMember -Function "Get-ChildItemPersonalized"
Export-ModuleMember -Alias "dir"
Export-ModuleMember -Alias "ls"
Export-ModuleMember -Alias "ll"
Export-ModuleMember -Alias "la"
Export-ModuleMember -Alias "l"


# cd to git root directory.
function cdgr() {
    Set-Location $(git root)
}
Export-ModuleMember -Function "cdgr"


# Pushd to git root directory.
function pushgr() {
    Push-Location $(git root)
}
Export-ModuleMember -Function "pushgr"


# Create a directory and cd into it
function mcd([string] $location) {
    mkdir $location | Set-Location
}
Export-ModuleMember -Function "mcd"


# Go up [n] directories.
function up([int] $n = 1) {
    $path = $pwd
    for ($i = 0; ($i -lt $n) -and ($path.Parent); $i++) {
        $path = $path.Parent
    }
    Set-Location $path
}
Export-ModuleMember -Function "up"


# Pushd up [n] directories.
function pushup([int] $n = 1) {
    $path = $pwd
    for ($i = 0; ($i -lt $n) -and ($path.Parent); $i++) {
        $path = $path.Parent
    }
    Push-Location $path
}
Export-ModuleMember -Function "pushup"


# Execute a command in a specific directory.
function xin([string] $location, [object] $command) {
    Push-Location $location
    try {
        if ($command -is [ScriptBlock]) {
            & $command
        } else {
            Invoke-Expression $command
        }
    } finally {
        Pop-Location
    }
}
Export-ModuleMember -Function "xin"


# Mirror stdout to stderr, useful for seeing data going through a pipe.
function peek() {
    $input | Tee-Object -Variable _ | Write-Error
    $_
}
Export-ModuleMember -Function "peek"
