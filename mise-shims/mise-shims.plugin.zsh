#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[mise] )); then return; fi

export PATH="$HOME/.local/share/mise/shims:$PATH"
source <(mise env | grep -v 'PATH=') # PATH binaries are handled by shims
