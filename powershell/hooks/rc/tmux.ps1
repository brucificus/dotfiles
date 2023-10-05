#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Credit:
#   - Oh-My-Zsh's tmux.plugin.zsh, see: https://github.com/ohmyzsh/ohmyzsh/blob/f4dc8c5be365668810783ced01a86ff8f251bfd7/plugins/tmux/tmux.plugin.zsh


if (-not (Test-Command tmux)) {
    append_profile_suggestions "# TODO: ⚡ Install 'tmux'."
    return
}

if (-not (Test-SessionInteractivity)) {
    return
}

phook_enqueue_module "poshy-wrap-tmux"

# CONFIGURATION VARIABLES
# Automatically start tmux
Set-EnvVar -Process -Name PWSHRC_TMUX_AUTOSTART -Value $false -SkipOverwrite
# Only autostart once. If set to false, tmux will attempt to
# autostart every time your zsh configs are reloaded.
Set-EnvVar -Process -Name PWSHRC_TMUX_AUTOSTART_ONCE -Value $true -SkipOverwrite
# Automatically connect to a previous session if it exists
Set-EnvVar -Process -Name PWSHRC_TMUX_AUTOCONNECT -Value $true -SkipOverwrite
# Automatically close the terminal when tmux exits
Set-EnvVar -Process -Name PWSHRC_TMUX_AUTOQUIT -Value $Env:PWSHRC_TMUX_AUTOSTART -SkipOverwrite
# Set term to screen or screen-256color based on current terminal support
Set-EnvVar -Process -Name PWSHRC_TMUX_FIXTERM -Value $true -SkipOverwrite
# Set '-CC' option for iTerm2 tmux integration
Set-EnvVar -Process -Name PWSHRC_TMUX_ITERM2 -Value $false -SkipOverwrite
# The TERM to use for non-256 color terminals.
# Tmux states this should be screen, but you may need to change it on
# systems without the proper terminfo
Set-EnvVar -Process -Name PWSHRC_TMUX_FIXTERM_WITHOUT_256COLOR -Value "screen" -SkipOverwrite
# The TERM to use for 256 color terminals.
# Tmux states this should be screen-256color, but you may need to change it on
# systems without the proper terminfo
Set-EnvVar -Process -Name PWSHRC_TMUX_FIXTERM_WITH_256COLOR -Value "screen-256color" -SkipOverwrite
# Set the configuration path
Set-EnvVar -Process -Name PWSHRC_TMUX_CONFIG -Value "$HOME/.tmux.conf" -SkipOverwrite
# Set -u option to support unicode
Set-EnvVar -Process -Name PWSHRC_TMUX_UNICODE -Value $true -SkipOverwrite

# Determine if the terminal supports 256 colors
if ( $Env:TERM -like "*-256color" ) {
  Set-EnvVar -Process -Name PWSHRC_TMUX_TERM -Value $Env:PWSHRC_TMUX_FIXTERM_WITH_256COLOR
} else {
  Set-EnvVar -Process -Name PWSHRC_TMUX_TERM -Value $Env:PWSHRC_TMUX_FIXTERM_WITHOUT_256COLOR
  export PWSHRC_TMUX_TERM=
}

# Set the correct local config file to use.
if ($Env:PWSHRC_TMUX_ITERM2 -eq $false -and (Test-Path $Env:PWSHRC_TMUX_CONFIG)) {
  Set-EnvVar -Process -Name _PWSHRC_TMUX_FIXED_CONFIG -Value "$PSScriptRoot/../../../shell/vendor/oh-my-zsh/plugins/tmux/tmux.extra.conf"
} else {
  Set-EnvVar -Process -Name _PWSHRC_TMUX_FIXED_CONFIG -Value "$PSScriptRoot/../../../shell/vendor/oh-my-zsh/plugins/tmux/tmux.only.conf"
}

# Wrapper function for tmux.
function _pwshrc_tmux_plugin_run() {
  [string] $tmux_bin = Search-CommandPath tmux
  if ($args) {
    &$tmux_bin @args
    return $?
  }

  [string[]] $tmux_args=@()

  if ($Env:PWSHRC_TMUX_ITERM2 -eq $true) {
    $tmux_args+=@("-CC")
  }
  if ($Env:PWSHRC_TMUX_UNICODE -eq $true) {
    $tmux_args+=("-u")
  }

  # Try to connect to an existing session.
  if (($Env:PWSHRC_TMUX_AUTOCONNECT -eq $true) -and $Env:PWSHRC_TMUX_DEFAULT_SESSION_NAME) {
    &$tmux_bin @tmux_args attach -t $Env:PWSHRC_TMUX_DEFAULT_SESSION_NAME
  } elseif ($Env:PWSHRC_TMUX_AUTOCONNECT -eq $true) {
    &$tmux_bin @tmux_args attach
  }

  # If failed, just run tmux, fixing the TERM variable if requested.
  if ( $LASTEXITCODE -ne 0 ) {
    if ( $Env:PWSHRC_TMUX_FIXTERM -eq $true ) {
      $tmux_args+=@("-f", $Env:_PWSHRC_TMUX_FIXED_CONFIG)
    } elseif ( Test-Path $Env:PWSHRC_TMUX_CONFIG -ErrorAction SilentlyContinue ) {
      $tmux_args+=@("-f", $Env:PWSHRC_TMUX_CONFIG)
    }
    if ( $Env:PWSHRC_TMUX_DEFAULT_SESSION_NAME ) {
      &$tmux_bin @tmux_args new-session -s $Env:PWSHRC_TMUX_DEFAULT_SESSION_NAME
    } else {
      &$tmux_bin @tmux_args new-session
    }
  }

  if ($Env:PWSHRC_TMUX_AUTOQUIT -eq $true) {
    [Environment]::Exit($LASTEXITCODE)
  }
}

# Alias tmux to our wrapper function.
Set-Alias -Name tmux -Value _pwshrc_tmux_plugin_run

# Autostart if not already in tmux and enabled.
if ((-not "$Env:TMUX") -and ($Env:PWSHRC_TMUX_AUTOSTART -eq $true) -and (-not $Env:INSIDE_EMACS) -and (-not $Env:EMACS) -and (-not $Env:VIM)) {
  # Actually don't autostart if we already did and multiple autostarts are disabled.
  if (($Env:PWSHRC_TMUX_AUTOSTART_ONCE -eq $false) -or ($Env:PWSHRC_TMUX_AUTOSTARTED -eq $false)) {
    Set-EnvVar -Process -Name PWSHRC_TMUX_AUTOSTARTED -Value $true
    _pwshrc_tmux_plugin_run
  }
}
