#!/usr/bin/env sh


shellspec_version="0.28.1"
if [ "$(command -v curl)" ]; then
    curl -fsSL https://raw.githubusercontent.com/shellspec/shellspec/$shellspec_version/install.sh | sh
elif [ "$(command -v wget)" ]; then
    wget -O- https://raw.githubusercontent.com/shellspec/shellspec/$shellspec_version/install.sh | sh
else
    echo "Neither \"curl\" nor \"wget\" exists on system."
    exit 1
fi
