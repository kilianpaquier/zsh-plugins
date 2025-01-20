if (( ! $+commands[mise] )); then
  curl -fsSL https://mise.run | sh
fi

if [ -z "$NO_MISE_ALIAS" ] && [ ! -f "$HOME/.config/mise/conf.d/mise.dotfiles.toml" ]; then
mkdir -p "$HOME/.config/mise/conf.d"
cat << EOF > "$HOME/.config/mise/conf.d/mise.dotfiles.toml"
[alias]
craft = "ubi:kilianpaquier/craft"
gitlab-storage-cleaner = "ubi:kilianpaquier/gitlab-storage-cleaner"
go-builder-generator = "ubi:kilianpaquier/go-builder-generator"
EOF
fi

if (( $+functions[_evalcache] )); then
  _evalcache mise activate zsh
  _evalcache mise completion zsh
else
  eval "$(mise activate zsh)"
  eval "$(mise completion zsh)"
fi
