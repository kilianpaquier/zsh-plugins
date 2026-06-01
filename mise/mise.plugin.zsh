#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[mise] )); then curl -fSL https://mise.run | sh; fi
