#!/bin/zsh
# shellcheck disable=SC1071

bin_dir="${0:A:h}/bin"
[[ -n ${path[(r)$bin_dir]} ]] || path+=("$bin_dir")
unset bin_dir

# Completes the platforms, then the options read from --help, without the '-' of its requirement lines.
if (( $+functions[compdef] )); then compdef "_arguments ':source:(github gitlab)' ':target:(github gitlab)' '*:tag: ' -- -i '(-)'" release-sync; fi
