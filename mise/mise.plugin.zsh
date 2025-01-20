if (( ! $+commands[mise] )); then
  curl -fsSL https://mise.run | sh
fi

: "${XDG_CONFIG_HOME:="$HOME/.config/zsh"}"

if [ -z "$NO_MISE_ALIAS" ] && [ ! -f "$XDG_CONFIG_HOME/mise/conf.d/mise.dotfiles.toml" ]; then
mkdir -p "$XDG_CONFIG_HOME/mise/conf.d"
cat << EOF > "$XDG_CONFIG_HOME/mise/conf.d/mise.dotfiles.toml"
[alias]
craft = "ubi:kilianpaquier/craft"
gitlab-storage-cleaner = "ubi:kilianpaquier/gitlab-storage-cleaner"
go-builder-generator = "ubi:kilianpaquier/go-builder-generator"
EOF
fi

if (( ! $+commands[_evalcache] )); then
  _evalcache mise activate zsh
  _evalcache mise completion zsh
else
  eval <(mise activate zsh)
  eval <(mise completion zsh)
fi
