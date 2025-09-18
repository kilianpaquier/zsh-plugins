#!/bin/zsh
# shellcheck disable=SC1071

if (( $+commands[opentofu] )); then
    alias tf="opentofu"
elif (( $+commands[terraform] )); then
    alias tf="terraform"
fi
