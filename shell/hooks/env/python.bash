#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


CONDA="$HOME/miniconda3/bin/conda"
if [ -x "$CONDA" ] && ! command_exists conda; then
    path_append "$HOME/miniconda3/bin"
fi
unset CONDA
