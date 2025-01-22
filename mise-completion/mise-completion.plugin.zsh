if (( ! $+commands[mise] )); then return; fi

completions="${XDG_CACHE_HOME:-"$HOME/.cache/zsh"}/completions"
fpath+=("$completions")
[ ! -f "$completions/_mise" ] && mkdir -p "$completions" && mise completion zsh > "$completions/_mise"
unset completions
