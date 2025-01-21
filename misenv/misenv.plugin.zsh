if (( $+functions[_evalcache] )); then
  _evalcache mise activate zsh
  _evalcache mise completion zsh
else
  eval "$(mise activate zsh)"
  eval "$(mise completion zsh)"
fi
