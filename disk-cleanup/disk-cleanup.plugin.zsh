#!/bin/zsh
# shellcheck disable=SC1071

bin_dir="${0:A:h}/bin"
[[ -n ${path[(r)$bin_dir]} ]] || path+=("$bin_dir")
unset bin_dir
