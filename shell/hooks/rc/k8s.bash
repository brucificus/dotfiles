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


if command_exists kubectl; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/kubectl.completion.bash
        source "$BASHIT_ALIASES_AVAILABLE"/kubectl.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(kubectl)  # https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/kubectl/README.md
    fi
elif command_exists docker; then
    append_profile_suggestions "# TODO: ⛵️ Install \`kubectl\`. See: https://kubernetes.io/docs/tasks/tools/."
fi

if command_exists kubectx; then
    if [ -n "$BASH_VERSION" ]; then
        : # 🙁
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(kubectx)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectx
    fi
elif command_exists kubectl || command_exists minikube; then
    append_profile_suggestions "# TODO: ⛵️ Install \`kubectx\`. See: https://github.com/ahmetb/kubectx#installation."
fi

if command_exists minikube; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/minikube.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(minikube)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/minikube
    fi
elif command_exists docker || command_exists kubectl; then
    append_profile_suggestions "# TODO: ⛵ Install \`minikube\`. See: https://kubernetes.io/docs/tasks/tools/."
fi

if command_exists helm; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/helm.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(helm)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/helm
    fi
elif command_exists kubectl || command_exists minikube; then
    append_profile_suggestions "# TODO: 🛞 Install \`helm\`. See: https://helm.sh/docs/intro/install/."
fi
