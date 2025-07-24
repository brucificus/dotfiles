#!/usr/bin/env bash


# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [[ "$TERM" == "xterm-color" || "$TERM" == *"-256color" ]]; then
    # Enable color prompt support because the terminal claims to support it.
    color_prompt=yes
elif [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
fi

if ! command_exists "oh-my-posh"; then
    # Use Kali Linux default prompt since we don't have oh-my-posh.
    # TODO: Fix not reading any changes that kali-tweaks made to these variables.
    #       ('kali-tweaks' overwrites them in `~/.config/powershell/Microsoft.PowerShell_profile.ps1`.)
    PROMPT_ALTERNATIVE=twoline
    NEWLINE_BEFORE_PROMPT=yes; export NEWLINE_BEFORE_PROMPT
    [ "$NEWLINE_BEFORE_PROMPT" = yes ] && PROMPT_COMMAND="PROMPT_COMMAND=echo"

    # hide EOL sign ('%')
    PROMPT_EOL_MARK=""; export PROMPT_EOL_MARK
fi
    # Use Kali Linux default prompt since we don't have oh-my-posh.
if [ "$color_prompt" = yes ]; then
    # ...continue setting up the Kali Linux default prompt. We expect this to have no effect if/when
    #    a latter script loads in something like oh-my-posh.

    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1; export VIRTUAL_ENV_DISABLE_PROMPT

    prompt_color='\[\033[;32m\]'
    info_color='\[\033[1;34m\]'

    if command_exists "kali-tweaks"; then
        # Use the Kali logo as the prompt symbol (requires Nerd Fonts).
        prompt_symbol=㉿
    else
        # Default to a generic symbol representing *nix. (Penguin emoji.)
        prompt_symbol=🐧
    fi
    if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
        prompt_color='\[\033[;94m\]'
        info_color='\[\033[1;31m\]'
        # Skull emoji for root terminal (requires Unicode font support).
        prompt_symbol=💀
    fi
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PS1=$prompt_color'┌──${debian_chroot:+($debian_chroot)──}${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)'$prompt_color')}('$info_color'\u'$prompt_symbol'\h'$prompt_color')-[\[\033[0;1m\]\w'$prompt_color']\n'$prompt_color'└─'$info_color'\$\[\033[0m\] ';;
        oneline)
            PS1='${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV)) }${debian_chroot:+($debian_chroot)}'$info_color'\u@\h\[\033[00m\]:'$prompt_color'\[\033[01m\]\w\[\033[00m\]\$ ';;
        backtrack)
            PS1='${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV)) }${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ';;
        *)
        # TODO: Default case for prompt???????????????
            PS1='';;
    esac
    unset prompt_color
    unset info_color
    unset prompt_symbol
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt
