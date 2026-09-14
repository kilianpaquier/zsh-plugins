#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[gitlab-ci-local] )); then return; fi

completions="${XDG_CACHE_HOME:-"$HOME/.cache/zsh"}/completions"
fpath+=("$completions")
[ ! -f "$completions/_gitlab-ci-local" ] && mkdir -p "$completions" && gitlab-ci-local --completion > "$completions/_gitlab-ci-local"
unset completions
