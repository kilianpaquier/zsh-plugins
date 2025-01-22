if (( ! $+commands[mise] )); then return; fi

if (( $+functions[_evalcache] )); then _evalcache mise activate zsh; else eval "$(mise activate zsh)"; fi
