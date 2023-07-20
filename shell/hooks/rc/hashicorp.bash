#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/aliases/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/completion/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/plugins/available


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if command_exists consul; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/consul.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # 🙁
    fi
fi

if command_exists packer; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/packer.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # 🙁
    fi
elif command_exists aws || command_exists az || command_exists vagrant || command_exists docker || command_exists vboxmanage; then
    append_profile_suggestions "# TODO: 📦 Install \`packer\`. See: https://developer.hashicorp.com/packer/downloads."
fi

if command_exists terraform; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/terraform.completion.bash
        source "$BASHIT_ALIASES_AVAILABLE"/terraform.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            terraform  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/terraform
        )
    fi
elif command_exists az || command_exists aws; then
    append_profile_suggestions "# TODO: ☄️ Install \`terraform\`. See: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli."
fi

if command_exists terragrunt; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_ALIASES_AVAILABLE"/terragrunt.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # 🙁
    fi
elif command_exists terraform; then
    append_profile_suggestions "# TODO: 🪖 Install \`terragrunt\`. See: https://terragrunt.gruntwork.io/docs/getting-started/install/."
fi

if command_exists vagrant; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/vagrant.completion.bash
        source "$BASHIT_ALIASES_AVAILABLE"/vagrant.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(vagrant)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vagrant
    fi
elif command_exists packer || command_exists vboxmanage; then
    append_profile_suggestions "# TODO: ⛺ Install \`vagrant\`. See: https://developer.hashicorp.com/vagrant/downloads."
fi

if command_exists vault; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_ALIASES_AVAILABLE"/vault.aliases.bash
        source "$BASHIT_COMPLETIONS_AVAILABLE"/vault.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(vault)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vault
    fi
# else
#     append_profile_suggestions "# TODO: 🔐 Install \`vault\`. See: https://developer.hashicorp.com/vault/docs/install."
fi

if command_exists nomad; then
    if ! command_exists damon; then
        append_profile_suggestions "# TODO: 🧑‍💻 Install \`damon\`. See: https://github.com/hashicorp/damon#installation."
    fi
elif command_exists docker || command_exists kubectl || command_exists minikube || command_exists helm; then
    append_profile_suggestions "# TODO: ⛺ Install \`nomad\`. See: https://developer.hashicorp.com/nomad/downloads."
fi
