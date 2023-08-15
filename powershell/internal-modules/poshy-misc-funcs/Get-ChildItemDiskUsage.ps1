function Get-ChildItemDiskUsage {

    if ($IsLinux) {
        du -h --max-depth=1 @args
    } elseif ($IsMacOS) {
        du -hd 1 @args
    } elseif ($IsWindows) {

    } else {
        throw [System.PlatformNotSupportedException]::new("Unknown platform: ${PSVersionTable.OS}")
    }
}
