# Bruce's Dotfiles

## What's this?

> ⚠️ These are dotfiles personalized for my own idiosyncrasies, they might not be particularly useful for strangers.
> 👆 Please feel free to peruse anyway, though, in case you are interested in setting something like this up for yourself.

The basics?

After cloning this repo, run `install` - in one of PowerShell, Bash, or ZSH. It will automatically set up the shell personalizations that I use on a daily basis.

The install script is idempotent: it can safely be run multiple times.

> ℹ️ NOTE: This repo contains cross-machine *shared* content. Machine-specific configuration is located in branches of [`dotfiles-local`](https://github.com/brucificus/dotfiles-local).

## 🚀 Usage

### 🪜 Prerequisites

This repo uses a Git submodule of [anishathalye/dotbot](https://github.com/anishathalye/dotbot) for installation.

You'll need Git, obviously. Also Python, for Dotbot.

And a shell. One or more of: PowerShell, ZSH, or Bash.

This repo gets regular usage on Windows 10, Windows 11, and Ubuntu 22 LTS (under WSL2). It tolerates slightly older versions of Ubuntu, but I don't test on them and can't guarantee compatibility.

#### 🪟 Windows & Symlinks

If you are using a modern version of Windows, you'll need to enable Developer Mode in the Windows Settings app, and configure it to enable the creation of symlinks.

If you are using an older version of Windows, you'll need to run the install script in an elevated session.

> ⚠️ If you use an elevated session to install, be aware that some programs may not work as expected. Files/folders created in elevated sessions are owned by the `Administrators` group, rather than your user account.

### 📦 Installation

Per my conventions, this is the workflow that works well for me (for machines that already have branches in `dotfiles-local`):

#### 1. Clone the repos

You've got to get this repo and its Git submodules onto your machine. If you've got `git` and access to the internet, this is fairly straightforward.

<details>
<summary>Pwsh</summary>

```powershell
cd ~
mkdir source/repos/_forks
cd source/repos/_forks
git clone https://github.com/brucificus/dotfiles.git brucificus--dotfiles --recurse-submodules
git clone https://github.com/brucificus/dotfiles-local.git brucificus--dotfiles-local --recurse-submodules
```

</details>

<details>
<summary>Bash/Zsh</summary>

```bash
cd ~
mkdir -p source/repos/_forks
cd source/repos/_forks
git clone https://github.com/brucificus/dotfiles.git brucificus--dotfiles --recurse-submodules
git clone https://github.com/brucificus/dotfiles-local.git brucificus--dotfiles-local --recurse-submodules
```

</details>

> 👆 If you *don't* have Git (or internet access from the machine), you can download the repos as ZIP files and extract them to the correct locations. You'll also need to download the Dotbot submodule separately, and extract it to the correct location.

#### 2. Switch to the correct branch for `dotfiles-local`

<details>
<summary>Pwsh</summary>

```powershell
cd brucificus--dotfiles-local
[string] $correctlyCasedHostname = $(Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters).Hostname
git switch origin/personal/$correctlyCasedHostname/win -c personal/$correctlyCasedHostname/win --track
```

</details>

<details>
<summary>Bash/Zsh</summary>

```bash
cd brucificus--dotfiles-local
git switch origin/personal/$NAME/wsl -c personal/$NAME/wsl --track
```

</details>

#### 3. Run setup for `dotfiles` and `dotfiles-local`

<details>
<summary>Pwsh</summary>

```powershell
cd ../brucificus--dotfiles
./install.ps1 # then correct conflicts and re-run
cd ../brucificus--dotfiles-local
./install.ps1 # then correct conflicts and re-run
```

</details>

<details>
<summary>Bash/Zsh</summary>

```bash
cd ../brucificus--dotfiles
chmod +x ./install.sh
./install.sh # then correct conflicts and re-run
cd ../brucificus--dotfiles-local
chmod +x ./install.sh
./install.sh # then correct conflicts and re-run
```

</details>

### 🔧 Customization Scripts: Making Local (Non-Git) Customizations

When using this repo, you may make local customizations by creating script files with particular names in your home directory, depending on the shell you use. This allows you to make changes that are specific to your machine, without having to commit them to a Git repository.

The naming pattern is, roughly, `~/.{shell}{stage}_local_{when}[.{ext}]`.

Files with these names (in your home directory!) are sourced by this repo's shell startup scripts, and can be used to set up environment variables, aliases, functions, and other shell configuration that is specific to your machine and too sensitive to be stored in a Git repository.

The scripts are sourced in a particular order, depending on the shell being used and the stage of the shell startup process.

#### 📝 Common Customization Scripts

<details>
<summary>Zsh, Bash, or Dash</summary>

| File Name | Shell | When It Runs |
| --- | --- | --- |
| `~/.shell_local_before` | Zsh/Bash/Dash | First, before any other shell scripts. |
| `~/.zshrc_local_before` | Zsh only | Runs before `.zshrc`. |
| `~/.zshrc_local_after` | Zsh only | Runs after `.zshrc`. |
| `~/.shell_local_after` | Zsh/Bash/Dash | Last, after all other scripts. |

</details>

<details>
<summary>PowerShell</summary>

| File Name | When It Runs |
| --- | --- |
| `~/.shell_local_before.ps1` | First, before any other shell scripts. |
| `~/.shellrc_local_before.ps1` | 2nd |
| `~/.pwshrc_local_before.ps1` | 3rd |
| `~/.pwshrc_local_after.ps1` | n-2 |
| `~/.shellrc_local_after.ps1` | n-1 |
| `~/.shell_local_after.ps1` | Last, after all other scripts. |

</details>

#### 🔬 Niche Details

Regardless as to shell, the customization scripts are sourced based on an order of precedence, with names keyed for the shell in question as well as the "stage" of the shell startup process.

This allows a lot of flexibility in customizing the shell startup process.

The "shell" keywords in the filename patterns are:

- `shell`, for all shells;
- `zsh`, for Zsh only;
- `bash`, for Bash only;
- `pwsh`, for PowerShell only.

The "stage" keywords supported in the filename patterns are as follows (except for PowerShell):

- `env`, for environment setup;
- `rc`, for shell configuration;
- `login`, for login shell configuration;
- `logout`, for session cleanup.

(We only support an `rc` stage for PowerShell.)

I don't really use this feature much, but it's there in case it's needed.

### 🧹 Uninstallation

Good luck with that. 😅
