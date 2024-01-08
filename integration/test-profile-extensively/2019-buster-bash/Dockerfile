# ---------------------------------------------------------------------------------------
FROM mcr.microsoft.com/dotnet/runtime-deps:3.1.17-buster-slim as prereqs

# Install the tools that are needed for _installing_ the `dotfiles` itself.
RUN apt-get update \
    && apt-get install -y --no-install-recommends git unzip python3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------------------
FROM prereqs as dotfiles_installed

# Clean up default shell profile files that would otherwise make the `dotfiles` setup fail.
WORKDIR /root
RUN rm ./.bashrc || true

# Add the content of the `dotfiles`-based setup.
WORKDIR /root/projects
ADD . ./dotfiles

# Install the `dotfiles`-based setup.
WORKDIR /root/projects/dotfiles
RUN ./install.sh

WORKDIR /root


# ---------------------------------------------------------------------------------------
FROM prereqs as final

# Install tooling that the profile uses/enhances. (Initial minimums.)
RUN apt-get update \
    && apt-get install -y --no-install-recommends procps less curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install tooling that the profile uses/enhances. (Extended selection.)
# NOTE: `buster` doesn't have packages for `pip`, `yq`, or `zoxide`.
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-client nano neovim golang gpg-agent nmap nginx nodejs npm imagemagick jq fzf direnv screen tmux \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install the specific shell we will be testing under.
RUN apt-get update \
    && apt-get install -y --no-install-recommends bash \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Grab the copy of the "installed" `dotfiles`.
COPY --from=dotfiles_installed /root /root

WORKDIR /root
CMD ["bash", "--noprofile", "--norc", "-c", ". ./.bashrc"]
