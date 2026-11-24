#!/bin/zsh
# shellcheck disable=SC1071

bin_dir="${0:A:h}/bin"
[[ -n ${path[(r)$bin_dir]} ]] || path+=("$bin_dir")
unset bin_dir

# Completes the options read from --help, without the '-' of its requirement lines, since the command takes no argument.
if (( $+functions[compdef] )); then compdef "_arguments -- -i '(-)'" disk-cleanup; fi
