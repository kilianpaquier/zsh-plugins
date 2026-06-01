#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[jdtls] )); then
  data=${XDG_DATA_HOME:-"$HOME/.local/share"}
  mkdir -p "$data/jdtls"
  curl -fSL http://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz | tar -xz -C "$data/jdtls"
  ln -sf "$data/jdtls/bin/jdtls" "$HOME/.local/bin/jdtls"
fi
