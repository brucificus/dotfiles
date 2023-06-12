function Measure-EnvVarChanges([ScriptBlock] $inner) {
    [Hashtable] $before = @{}
    Get-ChildItem Env:\ | %{ $orig[$_.Name] = $_.Value }

    &$inner

    [Hashtable] $after = @{}
    Get-ChildItem Env:\ | %{ $after[$_.Name] = $_.Value }

    return ($orig.Keys + $after.Keys) `
            | Select-Object -Unique `
            | %{ New-Object PSCustomObject -Property @{key = $_; before=$orig[$_]; after=$after[$_]}} `
            | ?{$_.before -ne $_.after}
}

function Test-Elevation() {
    Write-Debug "Testing elevation"
    if ($IsWindows) {
        return [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    } else {
        throw [System.NotImplementedException]::new("Test-Elevation not implemented for current platform")
    }
}

# Reads a dotenv file as a stream of key-value pairs.
function Read-DotEnv() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName="FilePath", Position=0)]
        [string] $FilePath
    )
    Process {
        foreach ($line in (Get-Content -LiteralPath $FilePath)) {
            [int] $splitAt = $line.IndexOf('=')
            if ($splitAt -gt -1) {
                [string] $key = $line.Substring(0, $splitAt)
                [string] $value = $line.Substring($splitAt+1)
                
                [string] $valueTrimmed = $value.Trim()
                if ($valueTrimmed.StartsWith('"') -and $valueTrimmed.EndsWith('"')) {
                    $value = $valueTrimmed.Substring(1, $valueTrimmed.Length-2)
                }

                [System.Collections.Generic.KeyValuePair[string,string]] $kvp = [System.Collections.Generic.KeyValuePair[string,string]]::new($key, $value)
                Write-Output $kvp
            }
        }
    }
}

# Sets an environment variable, requiring explicit specification of scope.
# Can accept pipeline of objects with properties `Key` and `Value`.
function Set-Env() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeKAV", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeKVP", Position=0)]
        [switch] $Machine,

        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeKAV", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeKVP", Position=0)]
        [switch] $Process,

        [Parameter(Mandatory=$true, ParameterSetName="UserScopeKAV", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeKVP", Position=0)]
        [switch] $User,

        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueKAV", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueKVP", Position=0)]
        [System.EnvironmentVariableTarget] $Scope,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeKAV", Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeKAV", Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeKAV", Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueKAV", Position=1, ValueFromPipelineByPropertyName=$true)]
        [string] $Key,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeKAV", Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeKAV", Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeKAV", Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueKAV", Position=2, ValueFromPipelineByPropertyName=$true)]
        [object] $Value,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeKVP", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeKVP", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeKVP", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueKVP", Position=1, ValueFromPipeline=$true)]
        [System.Collections.Generic.KeyValuePair[string, object]] $KVP
    )
    Begin {
        if ($Machine -and $Machine.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Machine
        } elseif ($Process -and $Process.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Process
        } elseif ($User -and $User.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::User
        }

        if (-not [System.EnvironmentVariableTarget]::IsDefined($Scope)) {
            Write-Error "Unrecognized EnvironmentVariableTarget: $Scope"
        }

        if ($IsWindows -and ($Scope -ne [System.EnvironmentVariableTarget]::Process)) {
            [bool] $isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            if (-not $isElevated) {
                Write-Error "Elevated session required for EnvironmentVariableTarget: $Scope"
            }
        }

        if ($KVP) {
            $Key = $KVP.Key
            $Value = $KVP.Value
        }
    }
    Process {
        [System.Environment]::SetEnvironmentVariable($Key, $Value, $Scope)
    }
}


Export-ModuleMember -Function "Measure-EnvVarChanges"
Export-ModuleMember -Function "Test-Elevation"
Export-ModuleMember -Function "Read-DotEnv"
Export-ModuleMember -Function "Set-Env"
