# ---------------------------------------------------------------------------------------
FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-jammy as prereqs

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

# Install tooling that the profile uses/enhances. (Minimums _only.)
RUN apt-get update \
    && apt-get install -y --no-install-recommends procps less curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Grab the copy of the "installed" `dotfiles`.
COPY --from=dotfiles_installed /root /root

# Install the specific shell we will be testing under.
RUN /root/.dotfiles/bin/install_pwsh.sh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /root
CMD ["pwsh", "-NoProfile", "-c", ". ./.config/powershell/profile.ps1"]
