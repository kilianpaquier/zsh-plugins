#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[chezmoi] )); then return; fi

completions="${XDG_CACHE_HOME:-"$HOME/.cache/zsh"}/completions"
fpath+=("$completions")
[ ! -f "$completions/_chezmoi" ] && mkdir -p "$completions" && chezmoi completion zsh > "$completions/_chezmoi"
unset completions
