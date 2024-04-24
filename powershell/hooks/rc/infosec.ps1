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
        }
    }

    if (-not $Env:SSH_AUTH_SOCK -and $Env:SSH_AGENT_PID) {
        Remove-EnvVar -Process -Name SSH_AGENT_PID
    }

    # See https://dev.gnupg.org/T3883#183622
    [string] $gpgAgentConfPath = $null
    if ($IsWindows) {
        $gpgAgentConfPath = "${Env:APPDATA}\gnupg\gpg-agent.conf"
    } else {
        $gpgAgentConfPath = "${Env:HOME}/.gnupg/gpg-agent.conf"
    }
    [bool] $gpgAgentConfExists = Test-Path $gpgAgentConfPath -ErrorAction SilentlyContinue
    [Nullable[bool]] $gpgAgentConfEnableWin32OpensshSupport = $null
    [Nullable[bool]] $gpgAgentConfEnablePuttySupport = $null
    [Nullable[bool]] $gpgAgentConfEnableSshSupport = $null
    if ($gpgAgentConfExists) {
        [string[]] $gpgAgentConf = @(Get-Content -LiteralPath $gpgAgentConfPath | Where-Object { $_ -notmatch '^\s*#' } | ForEach-Object { $_.Trim() })
        $gpgAgentConfEnableWin32OpensshSupport = 'enable-win32-openssh-support' -in $gpgAgentConf
        $gpgAgentConfEnablePuttySupport = 'enable-putty-support' -in $gpgAgentConf
        $gpgAgentConfEnableSshSupport = 'enable-ssh-support' -in $gpgAgentConf
    }
    if ($gpgAgentConfExists) {
        if (-not $gpgAgentConfEnableSshSupport) {
            append_profile_suggestions "# TODO: 🔧 Add 'enable-ssh-support' to '$gpgAgentConfPath'. See: https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dssh_002dsupport."
        }
        if (-not $gpgAgentConfEnableWin32OpensshSupport -and $IsWindows) {
            append_profile_suggestions "# TODO: 🔧 Add 'enable-win32-openssh-support' to '$gpgAgentConfPath'. See: https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dwin32_002dopenssh_002dsupport."
        } elseif ($gpgAgentConfEnableWin32OpensshSupport -and (-not $IsWindows)) {
            append_profile_suggestions "# TODO: 🔥 Remove 'enable-win32-openssh-support' from '$gpgAgentConfPath' - it is only supported on Windows."
        }
        if ($gpgAgentConfEnablePuttySupport -and $IsWindows) {
            append_profile_suggestions "# TODO: 🔥 Remove 'enable-putty-support' from '$gpgAgentConfPath' - it conflicts with other programs acting as Pageant-style agents."
        } elseif ($gpgAgentConfEnablePuttySupport -and (-not $IsWindows)) {
            append_profile_suggestions "# TODO: 🔥 Remove 'enable-putty-support' from '$gpgAgentConfPath' - it is only supported on Windows."
        }
    }

    if ((-not $Env:SSH_AUTH_SOCK) -and $IsWindows) {
        [string] $defaultWindowsGpgOpenSshAgentPipePath = "\\.\pipe\openssh-ssh-agent"
        [bool] $defaultWindowsGpgOpenSshAgentPipeExists = Test-Path $defaultWindowsGpgOpenSshAgentPipePath -ErrorAction SilentlyContinue
        if ($gpgAgentConfEnableSshSupport -and $gpgAgentConfEnableWin32OpensshSupport) {
            if ($defaultWindowsGpgOpenSshAgentPipeExists) {
                Write-Information "🔒 GPG is configured to support OpenSSH on Windows, setting SSH_AUTH_SOCK to '$defaultWindowsGpgOpenSshAgentPipePath'."
                Set-EnvVar -Process -Name SSH_AUTH_SOCK -Value $defaultWindowsGpgOpenSshAgentPipePath

                append_profile_suggestions "setx /U SSH_AUTH_SOCK `"$defaultWindowsGpgOpenSshAgentPipePath`" # TODO: 🔧 Set environment variable 'SSH_AUTH_SOCK' at *user* scope to path of the named pipe of the SSH agent."
            } else {
                append_profile_suggestions "# TODO: 🔧 Ensure 'gpg-connect-agent' is running and configured correctly."
            }
        }
    }

    # TODO: Add support for WSL.
    # if (-not ($Env:SSH_AUTH_SOCK) -and $IsWSL) {
    # }

    if (-not ($Env:SSH_AUTH_SOCK)) {
        if ($gpgAgentConfEnableSshSupport -and (Test-Command gpgconf -ErrorAction SilentlyContinue) -and (-not $IsWindows)) {
            # We don't do this check on Windows because Windows OpenSSH cannot understand the pipe traffic when -not $gpgAgentConfEnableWin32OpensshSupport.

            # The test involving the gnupg_SSH_AUTH_SOCK_by variable is for the case where
            # the agent is started as gpg-agent --daemon /bin/sh, in which case the shell
            # inherits the SSH_AUTH_SOCK variable from the parent, gpg-agent.
            # See: https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=blob;f=agent/gpg-agent.c;hb=7bca3be65e510eda40572327b87922834ebe07eb#l1307
            if ($Env:gnupg_SSH_AUTH_SOCK_by -ne $PID) {
                [string] $gpgConfAgentSshSocket = (gpgconf --list-dirs agent-ssh-socket)
                if ($gpgConfAgentSshSocket -and (Test-Path $gpgConfAgentSshSocket -ErrorAction SilentlyContinue)) {
                    Write-Information "🔒 GPG is configured to support SSH, setting SSH_AUTH_SOCK to '$gpgConfAgentSshSocket'."
                    Set-EnvVar -Process -Name SSH_AUTH_SOCK -Value $gpgConfAgentSshSocket
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
