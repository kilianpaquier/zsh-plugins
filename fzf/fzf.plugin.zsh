: "${XDG_CACHE_HOME:="$HOME/.cache/zsh"}"

if [ ! -d "$XDG_CACHE_HOME/junegunn/fzf" ]; then
  git clone --quiet --depth 1 --recursive --shallow-submodules https://github.com/junegunn/fzf.git "$XDG_CACHE_HOME/junegunn/fzf"
  "$XDG_CACHE_HOME/junegunn/fzf/install" --bin
fi
