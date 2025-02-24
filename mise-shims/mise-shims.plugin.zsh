#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[mise] )); then return; fi

export PATH="$HOME/.local/share/mise/shims:$PATH"
