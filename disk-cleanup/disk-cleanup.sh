#!/bin/sh

# zsh autoloads this file as a function, keep option and trap changes out of the caller's shell
[ -z "$ZSH_VERSION" ] || setopt localoptions localtraps

# shellcheck disable=SC3040
(set -o pipefail >/dev/null 2>&1) && set -o pipefail

cleanup() {
  unset -f error info command_targets target_probe dir_size target_size target_clean \
    report_stale clean_stale \
    claude_stale_dirs claude_report claude_clean \
    codex_stale_dirs codex_report codex_clean \
    copilot_stale_dirs copilot_report copilot_clean \
    vscode_stale_dirs vscode_report vscode_clean \
    usage parse_arguments main cleanup
}
trap cleanup EXIT

# zsh aborts the function on Ctrl-C without running the EXIT trap
if [ -n "$ZSH_VERSION" ]; then
  TRAPINT() {
    cleanup
    return $((128 + $1))
  }
fi

#####################################################################
#
# Logging
#
#####################################################################

red='\033[0;31m'
blue='\033[0;34m'
no_color='\033[0m'

error() {
  printf "${red}ERROR${no_color} %s\n" "$1" >&2
  return 1
}

info() {
  printf "${blue}INFO${no_color} %s\n" "$1"
}

#####################################################################
#
# Paths
#
#####################################################################

claude_versions_dir="${XDG_DATA_HOME:-$HOME/.local/share}/claude/versions"
codex_current_link="$HOME/.codex/packages/standalone/current"
codex_releases_dir="$HOME/.codex/packages/standalone/releases"
copilot_pkg_dir="${XDG_CACHE_HOME:-$HOME/.cache}/copilot/pkg"
vscode_server_dir="$HOME/.vscode-server"

bun_cache_dir="${BUN_INSTALL_CACHE_DIR:-$HOME/.bun/install/cache}"
golangci_lint_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/golangci-lint"
maven_repository_dir="$HOME/.m2/repository"
pre_commit_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/pre-commit"
uv_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/uv"

#####################################################################
#
# Command targets (tool exposes its own clean/prune command)
#
#####################################################################

command_targets() {
  printf '%s\n' bun docker go golangci-lint mise mvn npm pre-commit uv
}

target_probe() {
  command -v "$1" >/dev/null 2>&1
}

dir_size() {
  [ -e "$1" ] || {
    printf '0B'
    return
  }
  du -sh "$1" 2>/dev/null | cut -f1
}

target_size() {
  case "$1" in
  bun) dir_size "$bun_cache_dir" ;;
  docker) docker system df --format '{{ .Type }}: {{ .Size }}' 2>/dev/null | awk -F': ' '{print tolower($1)": "$2}' | paste -sd ',' - | sed 's/,/, /g' ;;
  go) printf 'build %s, mod %s' "$(dir_size "$(go env GOCACHE)")" "$(dir_size "$(go env GOMODCACHE)")" ;;
  golangci-lint) dir_size "$golangci_lint_cache_dir" ;;
  mise) dir_size "$(mise cache path)" ;;
  mvn) dir_size "$maven_repository_dir" ;;
  npm) dir_size "$(npm config get cache 2>/dev/null)" ;;
  pre-commit) dir_size "$pre_commit_cache_dir" ;;
  uv) dir_size "$uv_cache_dir" ;;
  esac
}

target_clean() {
  case "$1" in
  bun) rm -rf "$bun_cache_dir" ;;
  docker)
    docker builder prune -f --filter 'until=120h'
    docker container prune -f --filter 'until=120h'
    docker image prune -af --filter 'until=120h'
    docker volume prune -f
  ;;
  go) go clean -cache -modcache ;;
  golangci-lint) golangci-lint cache clean ;;
  mise) mise cache clear && mise prune -y ;;
  mvn) rm -rf "$maven_repository_dir" ;;
  npm)
    npm_cache=$(npm config get cache 2>/dev/null)
    npm cache clean --force || return 1
    [ -z "$npm_cache" ] || rm -rf "$npm_cache/_npx"
    ;;
  pre-commit) pre-commit clean ;;
  uv) uv cache clean ;;
  esac
}

#####################################################################
#
# Tools stale management
#
#####################################################################

report_stale() {
  label="$1"
  stale="$2"

  if [ -z "$stale" ]; then
    info "$label: 0B"
    return 1
  fi

  echo "$stale" | while IFS= read -r dir; do
    info "$label: $(dir_size "$dir") $dir"
  done
  return 0
}

clean_stale() {
  stale="$1"
  [ -n "$stale" ] || return 0

  echo "$stale" | while IFS= read -r dir; do
    rm -rf "$dir"
  done
}

#####################################################################
#
# Claude Code: keep the active version, drop the rest
#
#####################################################################

claude_stale_dirs() {
  [ -d "$claude_versions_dir" ] || return 1

  active=$(find "$claude_versions_dir" -mindepth 1 -maxdepth 1 -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
  [ -n "$active" ] || return 1

  find "$claude_versions_dir" -mindepth 1 -maxdepth 1 -type f ! -path "$active"
}

claude_report() {
  stale_claude=$(claude_stale_dirs) || return 1
  report_stale claude-code "$stale_claude"
}

claude_clean() {
  clean_stale "$stale_claude"
}

#####################################################################
#
# Codex: keep the active version, drop the rest
#
#####################################################################

codex_stale_dirs() {
  [ -d "$codex_releases_dir" ] || return 1

  active=$(readlink -f "$codex_current_link" 2>/dev/null)
  [ -n "$active" ] || return 1

  find "$codex_releases_dir" -mindepth 1 -maxdepth 1 -type d ! -path "$active"
}

codex_report() {
  stale_codex=$(codex_stale_dirs) || return 1
  report_stale codex "$stale_codex"
}

codex_clean() {
  clean_stale "$stale_codex"
}

#####################################################################
#
# Copilot: keep the active version, drop the rest
#
#####################################################################

copilot_stale_dirs() {
  [ -d "$copilot_pkg_dir" ] || return 1

  active=$(find "$copilot_pkg_dir" -mindepth 2 -maxdepth 2 -type d -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
  [ -n "$active" ] || return 1

  find "$copilot_pkg_dir" -mindepth 2 -maxdepth 2 -type d ! -path "$active"
}

copilot_report() {
  stale_copilot=$(copilot_stale_dirs) || return 1
  report_stale copilot "$stale_copilot"
}

copilot_clean() {
  clean_stale "$stale_copilot"
}

#####################################################################
#
# VSCode Server: keep the running commit hash, drop the rest
#
#####################################################################

vscode_stale_dirs() {
  [ -d "$vscode_server_dir" ] || return 1

  active=$(find "$vscode_server_dir" -maxdepth 1 -type f -name 'code-*' -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
  [ -n "$active" ] || return 1
  hash=$(basename "$active" | sed 's/^code-//')

  for dir in "$vscode_server_dir"/code-* "$vscode_server_dir"/cli/servers/Stable-*; do
    [ -e "$dir" ] || continue
    case "$dir" in
    *"$hash") ;;
    *) printf '%s\n' "$dir" ;;
    esac
  done
  return 0
}

vscode_report() {
  stale_vscode=$(vscode_stale_dirs) || return 1
  report_stale vscode-server "$stale_vscode"
}

vscode_clean() {
  clean_stale "$stale_vscode"
}

#####################################################################
#
# CLI arguments
#
#####################################################################

run=
all=
help=
selected=

usage() {
  cat << 'EOF'
Usage: disk-cleanup.sh [--run [--all | --<tool> ...]]

Reclaim disk space from dev-tool caches (bun, go, docker, uv, npm, pre-commit, golangci-lint, mise, mvn) via their own clean commands,
and from stale Copilot, Claude Code, Codex, VSCode Server version directories.
Any tool not installed is skipped.

No flags: dry-run, report every detected target and its size, clean nothing.

Options:
  -r, --run         Required to clean anything. Alone (no -a, --all or --<tool>), cleans nothing.
  -a, --all         With --run, clean every detected target.
  -h, --help        Show this help.
  --bun             Cleans Bun install cache.
  --docker          Cleans build cache, containers, images, volumes older than 120h.
  --go              Cleans build cache and module cache.
  --golangci-lint   Cleans golangci-lint cache.
  --mise            Cleans cache and unused tool versions.
  --mvn             Cleans local Maven repository.
  --npm             Cleans npm cache and npx cache.
  --pre-commit      Cleans pre-commit cache.
  --uv              Cleans uv cache.
  --claude          Cleans stale Claude Code versions.
  --codex           Cleans stale Codex releases.
  --copilot         Cleans stale Copilot package versions.
  --vscode-server   Cleans stale VSCode Server versions.

--<tool> and --all select cleanup targets; they require --run and have no effect on the dry-run report.
EOF
}

parse_arguments() {
  while [ $# -gt 0 ]; do
    case "$1" in
    -r | --run) run=1; shift ;;
    -a | --all) all=1; shift ;;
    -h | --help) usage; help=1; return 0 ;;
    --bun|--docker|--go|--golangci-lint|--mise|--mvn|--npm|--pre-commit|--uv|--copilot|--claude|--codex|--vscode-server)
      selected="$selected ${1#--}"
      shift
      ;;
    *) usage; error "Unknown argument '$1'."; return 2 ;;
    esac
  done

  if { [ -n "$selected" ] || [ -n "$all" ]; } && [ -z "$run" ]; then
    usage
    error "Tool selection flags require '--run'."
    return 2
  fi
}

#####################################################################
#
# Main
#
#####################################################################

main() {
  parse_arguments "$@" || return $?
  [ -z "$help" ] || return 0

  detected=""
  # word-split: command_targets prints one target per line
  for name in $(command_targets); do
    target_probe "$name" || continue
    info "$name: $(target_size "$name")"
    detected="$detected $name"
  done

  has_claude=
  claude_report && has_claude=1
  has_codex=
  codex_report && has_codex=1
  has_copilot=
  copilot_report && has_copilot=1
  has_vscode=
  vscode_report && has_vscode=1

  [ -n "$run" ] || return 0

  clean_list=""
  clean_copilot=
  clean_claude=
  clean_codex=
  clean_vscode=

  if [ -n "$all" ]; then
    clean_list="$detected"
    clean_claude="$has_claude"
    clean_codex="$has_codex"
    clean_copilot="$has_copilot"
    clean_vscode="$has_vscode"
  else
    # word-split: $selected is a space-separated list built in parse_arguments
    for name in $selected; do
      case "$name" in
      claude) clean_claude="$has_claude" ;;
      codex) clean_codex="$has_codex" ;;
      copilot) clean_copilot="$has_copilot" ;;
      vscode-server) clean_vscode="$has_vscode" ;;
      *) clean_list="$clean_list $name" ;;
      esac
    done
  fi

  # word-split: $clean_list is a space-separated list built above
  for name in $clean_list; do
    if target_clean "$name"; then info "$name: cleaned"; else error "$name: cleanup failed"; fi
  done

  if [ -n "$clean_claude" ]; then
    if claude_clean; then info "claude-code: cleaned"; else error "claude-code: cleanup failed"; fi
  fi
  if [ -n "$clean_codex" ]; then
    if codex_clean; then info "codex: cleaned"; else error "codex: cleanup failed"; fi
  fi
  if [ -n "$clean_copilot" ]; then
    if copilot_clean; then info "copilot: cleaned"; else error "copilot: cleanup failed"; fi
  fi
  if [ -n "$clean_vscode" ]; then
    if vscode_clean; then info "vscode-server: cleaned"; else error "vscode-server: cleanup failed"; fi
  fi
}

main "$@"
