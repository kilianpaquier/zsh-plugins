cache="${XDG_CACHE_HOME:-"$HOME/.cache/zsh"}"
if [ ! -d "$cache/junegunn/fzf" ]; then
  git clone --quiet --depth 1 --recursive --shallow-submodules https://github.com/junegunn/fzf.git "$cache/junegunn/fzf"
  "$cache/junegunn/fzf/install" --bin
fi
unset cache