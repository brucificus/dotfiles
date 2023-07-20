#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if [ -z "$WSL_DISTRO_NAME" ]; then return 0; fi

# If we're in WSL, we need to do some specific PATH patching.

# Let's grab some helpful variables.
WINDOWS_USERNAME=$(cmd.exe /c echo "%USERNAME%" 2> /dev/null | tr -d '\r\n'); export WINDOWS_USERNAME
WINDOWS_USERPROFILE=$(wslpath -u "$(cmd.exe /c echo "%USERPROFILE%" 2> /dev/null | tr -d '\r\n')"); export WINDOWS_USERPROFILE
WINDOWS_ProgramData=$(wslpath -u "$(cmd.exe /c echo "%ProgramData%" 2> /dev/null | tr -d '\r\n')"); export WINDOWS_ProgramData
WINDOWS_ProgramFiles=$(wslpath -u "$(cmd.exe /c echo "%ProgramFiles%" 2> /dev/null | tr -d '\r\n')"); export WINDOWS_ProgramFiles
WINDOWS_ProgramFiles_x86=$(wslpath -u "$(cmd.exe /c echo "%ProgramFiles(x86)%" 2> /dev/null | tr -d '\r\n')"); export WINDOWS_ProgramFiles_x86
WINDOWS_SystemRoot=$(wslpath -u "$(cmd.exe /c echo "%SystemRoot%" 2> /dev/null | tr -d '\r\n')"); export WINDOWS_SystemRoot
WINDOWS_LOCALAPPDATA=$(wslpath -u "$(cmd.exe /c echo "%LOCALAPPDATA%" 2> /dev/null | tr -d '\r\n')"); export WINDOWS_LOCALAPPDATA
WINDOWS_ProgramW6432=$(wslpath -u "$(cmd.exe /c echo "%ProgramW6432%" 2> /dev/null | tr -d '\r\n')"); export WINDOWS_ProgramW6432

WINDOWS_Path=$(cmd.exe /c echo "%WINDOWS_Path%" 2> /dev/null | tr -d '\r\n')
WINDOWS_Path=$(echo "$WINDOWS_Path" | tr ';' '\n' | while read -r line; do wslpath -u "$line"; done | paste -sd ';')
export WINDOWS_Path

# Clear Windows-isms from the PATH.
# This prevents us from accidentally running the Windows versions of certain programs.
# This also *massively* speeds up command resolution in WSL.
prefixesOfPathsToRemove=(
    "$WINDOWS_ProgramData"
    "$WINDOWS_ProgramFiles"
    "$WINDOWS_ProgramFiles_x86"
    "$WINDOWS_SystemRoot"
    "$WINDOWS_LOCALAPPDATA"
    "$WINDOWS_ProgramW6432"
    "$WINDOWS_USERPROFILE/scoop"
    "$WINDOWS_USERPROFILE/.dotnet"
)
allowList=(
    "Microsoft VS Code"
)
printf '%s' "$PATH" | while read -d ':' -r pathItem; do
    for prefix in "${prefixesOfPathsToRemove[@]}"; do
        if [[ "$pathItem" == "$prefix"* ]]; then
            # If the path is in the allow list, don't remove it.
            for allowListItem in "${allowList[@]}"; do
                if [[ "$pathItem" == *"$allowListItem"* ]]; then
                    continue 2
                fi
            done
            path_removematch "$pathItem"; export PATH
            break
        fi
    done
done
unset prefixesOfPathsToRemove
