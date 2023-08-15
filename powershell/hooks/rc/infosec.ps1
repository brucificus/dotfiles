#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command gpg-agent) {
    # Fix for passphrase prompt on the correct tty
    # See https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dssh_002dsupport
    function _gpg-agent_update-tty_preexec {
        gpg-connect-agent updatestartuptty /bye | Out-Null
    }
    # TODO: add-pwsh-preexec-hook _gpg-agent_update-tty_preexec

    # If enable-ssh-support is set, fix ssh agent integration
    [string[]] $gpgconfGpgagentOptions = (gpgconf --list-options gpg-agent 2> $null)
    [PSObject] $enableSshSupportOption = (
        $gpgconfGpgagentOptions `
        | ConvertFrom-Csv -Delimiter ":" -Header name,flags,level,description,type,type-alt,argname,default,argdef,value `
        | Where-Object { $_.name -eq "enable-ssh-support" }
    )
    if ($enableSshSupportOption.value -eq 1) {
        Remove-EnvVar -Process -Name SSH_AGENT_PID

        # The test involving the gnupg_SSH_AUTH_SOCK_by variable is for the case where
        # the agent is started as gpg-agent --daemon /bin/sh, in which case the shell
        # inherits the SSH_AUTH_SOCK variable from the parent, gpg-agent.
        # See: https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=blob;f=agent/gpg-agent.c;hb=7bca3be65e510eda40572327b87922834ebe07eb#l1307
        if ($Env:gnupg_SSH_AUTH_SOCK_by -ne $PID) {
            [string] $gpgconfAgentsshsocket = (gpgconf --list-dirs agent-ssh-socket)
            Set-EnvVar -Process -Name SSH_AUTH_SOCK -Value $gpgconfAgentsshsocket
        }
    }
} elseif (Test-Command gpg) {
    append_profile_suggestions "# TODO: 🔑 Install 'gpg-agent'. See: https://www.gnupg.org/download/index.html."
} else {
    append_profile_suggestions "# TODO: 🔑 Install 'gpg'. See: https://www.gnupg.org/download/index.html."
}

if (Test-Command keychain) {
    # Define SHORT_HOST if not defined (%m = host name up to first .)
    if (-not $Env:SHORT_HOST) {
        Set-EnvVar -Process -Name SHORT_HOST -Value (hostname)
    }

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
        keychain @options --agents $agents @identities --host $SHORT_HOST | Out-Null

        # Get the filenames to store/lookup the environment from
        _keychain_env_sh="$HOME/.keychain/${SHORT_HOST}-sh"
        _keychain_env_sh_gpg="$HOME/.keychain/${SHORT_HOST}-sh-gpg"

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
