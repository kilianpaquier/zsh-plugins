#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[just] )); then return; fi

completions="${XDG_CACHE_HOME:-"$HOME/.cache/zsh"}/completions"
fpath+=("$completions")
[ ! -f "$completions/_just" ] && mkdir -p "$completions" && just --completions zsh > "$completions/_just"
unset completions
