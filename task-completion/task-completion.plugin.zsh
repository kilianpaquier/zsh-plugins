#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[task] )); then return; fi

completions="${XDG_CACHE_HOME:-"$HOME/.cache/zsh"}/completions"
fpath+=("$completions")
[ ! -f "$completions/_task" ] && mkdir -p "$completions" && task --completion zsh > "$completions/_task"
unset completions
