#!/usr/bin/env bash

set -e

CONFIG="install.conf.yaml"
DOTBOT_DIR="dotbot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive "${DOTBOT_DIR}"

[ -f shell/bash/bash-it/profiles/ ] && [ ! -L shell/bash/bash-it/profiles/ ] && rm -rf shell/bash/bash-it/profiles/ && rmdir shell/bash/bash-it/profiles/
[ -f shell/zsh/oh-my-zsh/custom/plugins/ ] && [ ! -L shell/zsh/oh-my-zsh/custom/plugins/ ] && rm -rf shell/zsh/oh-my-zsh/custom/plugins/ && rmdir shell/zsh/oh-my-zsh/custom/plugins/

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
