#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


try {
    if (Test-Command gpg-connect-agent) {
        # Fix for passphrase prompt on the correct tty
        # See https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dssh_002dsupport
        function _gpg-agent_update-tty_preexec {
            gpg-connect-agent updatestartuptty /bye | Out-Null
        }
        # TODO: add-pwsh-preexec-hook _gpg-agent_update-tty_preexec
    }

    if ($Env:SSH_AUTH_SOCK) {
        if (-not (Test-Path $Env:SSH_AUTH_SOCK -ErrorAction SilentlyContinue)) {
            Write-Information "SSH_AUTH_SOCK points to non-existent file '$Env:SSH_AUTH_SOCK', removing it."
            Remove-EnvVar -Process -Name SSH_AUTH_SOCK
            Remove-EnvVar -Process -Name SSH_AGENT_PID -ErrorAction SilentlyContinue
        }
    }

    if (-not ($Env:SSH_AUTH_SOCK) -and $IsWindows) {
        [string] $gpgAgentConfPath = "$Env:APPDATA\gnupg\gpg-agent.conf"
        if (Test-Path $gpgAgentConfPath) {
            function Get-GpgAgentConf {
                Get-Content -LiteralPath $gpgAgentConfPath | Where-Object { $_ -notmatch '^\s*#' } | ForEach-Object { $_.Trim() }
            }
            [string[]] $gpgAgentConf = Get-GpgAgentConf
            [bool] $gpgAgentConfEnableWin32OpensshSupport = 'enable-win32-openssh-support' -in $gpgAgentConf
            [bool] $gpgAgentConfEnablePuttySupport = 'enable-putty-support' -in $gpgAgentConf
            [bool] $gpgAgentConfEnableSshSupport = 'enable-ssh-support' -in $gpgAgentConf
            if (-not $gpgAgentConfEnableSshSupport) {
                append_profile_suggestions "# TODO: 🔑 Add 'enable-ssh-support' to '$gpgAgentConfPath'. See: https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dssh_002dsupport."
            }
            if (-not $gpgAgentConfEnableWin32OpensshSupport) {
                append_profile_suggestions "# TODO: 🔑 Add 'enable-win32-openssh-support' to '$gpgAgentConfPath'. See: https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dwin32_002dopenssh_002dsupport."
            }
            if (-not $gpgAgentConfEnablePuttySupport) {
                append_profile_suggestions "# TODO: 🔑 Add 'enable-putty-support' to '$gpgAgentConfPath'. See: https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dputty_002dsupport."
            }
            if ($gpgAgentConfEnableWin32OpensshSupport -and $gpgAgentConfEnablePuttySupport -and $gpgAgentConfEnableSshSupport) {
                # See https://dev.gnupg.org/T3883#183622
                [string] $windowsGpgOpenSshAgentPipe = "\\.\pipe\openssh-ssh-agent"
                if (Test-Path $windowsGpgOpenSshAgentPipe -ErrorAction SilentlyContinue) {
                    Write-Information "GPG is configured to support OpenSSH on Windows, setting SSH_AUTH_SOCK to '$windowsGpgOpenSshAgentPipe'."
                    Set-EnvVar -Process -Name SSH_AUTH_SOCK -Value $windowsGpgOpenSshAgentPipe

                    append_profile_suggestions "setx /U SSH_AUTH_SOCK `"$windowsGpgOpenSshAgentPipe`" # TODO: 🔧 Set environment variable 'SSH_AUTH_SOCK' at *user* scope to path of the named pipe of the SSH agent."
                } else {
                    append_profile_suggestions "# TODO: 🔑 Ensure 'gpg-connect-agent' is set to start automatically."
                }
            }
        }
    }

    # TODO: Add support for WSL.
    # if (-not ($Env:SSH_AUTH_SOCK) -and $IsWSL) {
    # }

    if (-not ($Env:SSH_AUTH_SOCK)) {
        if (Test-Command gpgconf) {
            function Get-GpgConfComponent {
                gpgconf --list-components | ConvertFrom-Csv -Delimiter ":" -Header name,description,path
                # TODO: Unescape elements.
            }

            function Get-GpgConfComponentOption {
                param(
                    [ValidateScript({ $_ -in (Get-GpgConfComponent | Select-Object -ExpandProperty name) }, ErrorMessage="Invalid component. See: Get-GpgConfComponent")]
                    [string] $Component
                )
                gpgconf --list-options $Component | ConvertFrom-Csv -Delimiter ":" -Header name,flags,level,description,type,type-alt,argname,default,argdef,value
                # TODO: Unescape elements.
            }

            # If enable-ssh-support is set, fix ssh agent integration
            [PSObject] $enableSshSupportOption = (Get-GpgConfComponentOption -Component 'gpg-agent' | Where-Object { $_.name -eq "enable-ssh-support" })

            if ($enableSshSupportOption.value -eq 1) {
                Remove-EnvVar -Process -Name SSH_AGENT_PID -ErrorAction SilentlyContinue

                # The test involving the gnupg_SSH_AUTH_SOCK_by variable is for the case where
                # the agent is started as gpg-agent --daemon /bin/sh, in which case the shell
                # inherits the SSH_AUTH_SOCK variable from the parent, gpg-agent.
                # See: https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=blob;f=agent/gpg-agent.c;hb=7bca3be65e510eda40572327b87922834ebe07eb#l1307
                if ($Env:gnupg_SSH_AUTH_SOCK_by -ne $PID) {
                    [string] $gpgConfAgentSshSocket = (gpgconf --list-dirs agent-ssh-socket)
                    if ($gpgConfAgentSshSocket -and (Test-Path $gpgConfAgentSshSocket -ErrorAction SilentlyContinue)) {
                        Write-Information "GPG is configured to support SSH, setting SSH_AUTH_SOCK to '$gpgConfAgentSshSocket'."
                        Set-EnvVar -Process -Name SSH_AUTH_SOCK -Value $gpgConfAgentSshSocket
                    }
                }
            }
        }
    }

    if (-not (Test-Command gpg)) {
        append_profile_suggestions "# TODO: 🔑 Install 'gpg'. See: https://www.gnupg.org/download/index.html."
    }

    if (Test-Command keychain) {
        function keychain-init {
            [string] $agents = $null
            [string[]] $identities = @()
            [string[]] $options = @()
            [string] $_keychain_env_sh = $null
            [string] $_keychain_env_sh_gpg = $null

            # load agents to start.
            $agents = zstyle -s :omz:plugins:keychain agents agents
            if (-not $agents) {
                $agents = "gpg"
            }

            # load identities to manage.
            # TODO: $identities = zstyle -a :omz:plugins:keychain identities identities

            # load additional options
            # TODO: $options = zstyle -a :omz:plugins:keychain options options

            # start keychain...
            keychain @options --agents $agents @identities --host $Env:SHORT_HOST | Out-Null

            # Get the filenames to store/lookup the environment from
            $_keychain_env_sh="${Env:HOME}/.keychain/${Env:SHORT_HOST}-sh"
            $_keychain_env_sh_gpg="${Env:HOME}/.keychain/${Env:SHORT_HOST}-sh-gpg"

            # Source environment settings.
            if (Test-Path -Path $_keychain_env_sh -ErrorAction SilentlyContinue) {
                # TODO: Read-DotEnv -Path $_keychain_env_sh | Set-EnvVar -Process
            }
            if (Test-Path -Path $_keychain_env_sh_gpg -ErrorAction SilentlyContinue) {
                # TODO: Read-DotEnv -Path $_keychain_env_sh_gpg | Set-EnvVar -Process
            }
        }
        # TODO: keychain-init

    } else {
        append_profile_suggestions "# TODO: 🔑 Install 'keychain'. See: https://www.funtoo.org/Keychain#Quick_Setup."
    }
} finally {
    Remove-Variable -Name gpgconfAgentsshsocket -ErrorAction SilentlyContinue
    Remove-Variable -Name gpgconfGpgagentOptions -ErrorAction SilentlyContinue
    Remove-Variable -Name enableSshSupportOption -ErrorAction SilentlyContinue
}
