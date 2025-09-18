#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[mise] )); then curl -fsSL https://mise.run | sh; fi
