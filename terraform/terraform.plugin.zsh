#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[terraform] )); then return; fi
alias tf="terraform"
