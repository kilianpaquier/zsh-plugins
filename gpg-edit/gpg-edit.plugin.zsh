#!/bin/zsh
# shellcheck disable=SC1071

bin_dir="${0:A:h}/bin"
[[ -n ${path[(r)$bin_dir]} ]] || path+=("$bin_dir")
unset bin_dir

# Completes the file, then the options read from --help, without the '-' of its requirement lines.
_gpg-edit() {
  _arguments ':file:_files -g "*.(asc|enc|gpg|pgp)(-.)"' -- -i '(-)'
}
if (( $+functions[compdef] )); then compdef _gpg-edit gpg-edit; fi
