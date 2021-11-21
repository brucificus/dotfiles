# Dotfiles

## About

After cloning this repo, run `install` to automatically set up the development
environment. Note that the install script is idempotent: it can safely be run
multiple times.

Dotfiles uses [Dotbot][dotbot] for installation.

This is cross-machine shared content. Machine-specific configuration, is located in branches of `dotfiles-local`.

## Making Local Customizations

You can make local customizations for some programs by editing these files:

* `zsh` / `bash` : `~/.shell_local_before` run first
* `zsh` : `~/.zshrc_local_before` run before `.zshrc`
* `zsh` : `~/.zshrc_local_after` run after `.zshrc`
* `zsh` / `bash` : `~/.shell_local_after` run last

## Installation Script

Per my conventions, this is the workflow that works well for me (for machines that already have branches in `dotfiles-local`):

#### 1. Clone the repos

```powershell
cd ~
mkdir source/repos/_forks # This is more drawn-out in bash 🙁
cd source/repos/_forks
git clone https://github.com/brucificus/dotfiles.git brucificus--dotfiles
git clone https://github.com/brucificus/dotfiles-local.git brucificus--dotfiles-local
```

#### 2. Switch to the correct branch for `dotfiles-local`

##### For Windows (specifically w/ PowerShell)

```powershell
cd brucificus--dotfiles-local
[string] $correctlyCasedHostname = $(Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters).Hostname
git switch origin/personal/$correctlyCasedHostname/win -c personal/$correctlyCasedHostname/win --track
```

##### For WSL (specifically w/ Bash)

```bash
cd brucificus--dotfiles-local
git switch origin/personal/$NAME/wsl -c personal/$NAME/wsl --track
```

#### 3. Run setup for `dotfiles` and `dotfiles-local`

##### For Windows (specifically w/ an *elevated* PowerShell, b/c symlinks)

```powershell
cd ../brucificus--dotfiles
./install.ps1 # then correct conflicts and re-run
cd ../brucificus--dotfiles-local
./install.ps1 # then correct conflicts and re-run
```

##### For WSL (specifically w/ Bash)

```bash
cd ../brucificus--dotfiles
chmod +x ./install.sh
./install.sh # then correct conflicts and re-run
cd ../brucificus--dotfiles-local
chmod +x ./install.sh
./install.sh # then correct conflicts and re-run
```
