if (( ! $+commands[mise] )); then curl -fsSL https://mise.run | sh; fi

if [ -z "$NO_MISE_ALIAS" ] && [ ! -f "$HOME/.config/mise/conf.d/mise.dotfiles.toml" ]; then
mkdir -p "$HOME/.config/mise/conf.d"
cat << EOF > "$HOME/.config/mise/conf.d/mise.dotfiles.toml"
[alias]
craft = "ubi:kilianpaquier/craft"
gitlab-storage-cleaner = "ubi:kilianpaquier/gitlab-storage-cleaner"
go-builder-generator = "ubi:kilianpaquier/go-builder-generator"
EOF
fi
