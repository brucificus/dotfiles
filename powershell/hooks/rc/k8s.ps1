#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command kubectl) {
    phook_enqueue_module "poshy-wrap-kubectl"
} elseif (Test-Command docker) {
    append_profile_suggestions "# TODO: ⛵️ Install 'kubectl'. See: https://kubernetes.io/docs/tasks/tools/."
}

if (Test-Command kubectx) {
    # Intentionally left blank.
} elseif ((Test-Command kubectl) -or (Test-Command minikube)) {
    append_profile_suggestions "# TODO: ⛵️ Install 'kubectx'. See: https://github.com/ahmetb/kubectx#installation."
}

if (Test-Command minikube) {
    # Intentionally left blank.
} elseif ((Test-Command docker) -or (Test-Command kubectl)) {
    append_profile_suggestions "# TODO: ⛵ Install 'minikube'. See: https://kubernetes.io/docs/tasks/tools/."
}

if (Test-Command helm) {
    phook_enqueue_module "poshy-wrap-helm"
} elseif ((Test-Command kubectl) -or (Test-Command minikube)) {
    append_profile_suggestions "# TODO: 🛞 Install 'helm'. See: https://helm.sh/docs/intro/install/."
}
