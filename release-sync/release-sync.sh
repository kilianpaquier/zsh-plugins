#!/bin/sh

# shellcheck disable=SC3040
(set -o pipefail >/dev/null 2>&1) && set -o pipefail

#####################################################################
#
# Logging
#
#####################################################################

red='\033[0;31m'
blue='\033[0;34m'
no_color='\033[0m'

error() {
  printf "${red}ERROR - %s${no_color}\n" "$1" >&2
  return 1
}

info() {
  printf "${blue}INFO - %s${no_color}\n" "$1"
}

#####################################################################
#
# CLI arguments
#
#####################################################################

source_platform=
target_platform=
source_repository=
target_repository=
version=

required_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    error "Required command '$1' is required but wasn't found. Please install it."
    return 1
  fi
}

validate_platform() {
  case "$1" in
  github) required_command gh ;;
  gitlab) required_command glab ;;
  *) error "Invalid platform '$1'. Must be 'gitlab' or 'github'"; return 1 ;;
  esac
}

help() {
  cat << 'EOF'
Usage: release-sync.sh <source> <target> [version]

Synchronize releases from a source platform to a target platform.

Arguments:
  source  Source platform and repository (format: platform[:repository])
            - platform: 'github' or 'gitlab' (required)
            - repository: optional, auto-detected if not provided
            Example: github:owner/repo or gitlab

  target  Target platform and repository (format: platform[:repository])
            - platform: 'github' or 'gitlab' (required)
            - repository: optional, auto-detected if not provided
            Example: gitlab:group/project or github

  version Specific release version to sync (default: all releases synced)

Examples:
  # Sync all releases from GitHub to GitLab (auto-detect repositories)
  release-sync.sh github gitlab

  # Sync a specific version from GitHub to GitLab (auto-detect repositories)
  release-sync.sh github gitlab v1.0.0

  # Sync all releases with explicit repositories
  release-sync.sh github:owner/repo gitlab:group/project

  # Sync a specific version
  release-sync.sh github:owner/repo gitlab:group/project v1.0.0

Requirements:
  - 'gh' command (GitHub CLI) for GitHub operations
  - 'glab' command (GitLab CLI) for GitLab operations
  - 'jq' command for JSON processing
  - 'mktemp' command for temporary directory creation
  - 'tac' and 'tr' commands for text processing
EOF
}

parse_arguments() {
  [ $# -ge 2 ] || {
    help
    error "Missing required arguments."
    return $?
  }
  [ $# -le 3 ] || {
    help
    error "Too many arguments."
    return $?
  }

  source=$1
  target=$2
  version=$3
  shift 3 >/dev/null 2>&1 || true # last argument potentially not there

  case "$source" in
  *:*)
    source_platform="${source%:*}"   # gitlab:path/to/project
    source_repository="${source#*:}" # github:path/to/repository
    ;;
  *) source_platform=$source ;;
  esac

  case "$target" in
  *:*)
    target_platform="${target%:*}"   # github:path/to/repository
    target_repository="${target#*:}" # gitlab:path/to/project
    ;;
  *) target_platform=$target ;;
  esac

  validate_platform "$source_platform" || return 1
  validate_platform "$target_platform" || return 1

  if [ -z "$source_repository" ]; then
    source_repository=$(get_repository "$source_platform") || {
      error "Failed to retrieve repository from platform CLI"
      return 1
    }
  fi

  if [ -z "$target_repository" ]; then
    target_repository=$(get_repository "$target_platform") || {
      error "Failed to retrieve repository from platform CLI"
      return 1
    }
  fi
}

#####################################################################
#
# Releases synchronization
#
#####################################################################

get_repository() {
  platform=$1
  case "$platform" in
  github) gh repo view --json nameWithOwner --jq '.nameWithOwner' ;;
  gitlab) glab repo view --output json | jq -r '.path_with_namespace' ;;
  esac
  return $?
}

get_releases() {
  platform=$1
  repository=$2

  case "$platform" in
  github) gh -R "$repository" release list --json name --limit 100 ;;
  gitlab) glab api "projects/$(printf '%s' "$repository" | jq -sRr @uri)/releases" ;;
  esac
  return $?
}

get_release() {
  platform=$1
  repository=$2
  release=$3

  case "$platform" in
  github) gh -R "$repository" release view "$release" --json name,body,publishedAt ;;
  gitlab) glab api "projects/$(printf '%s' "$repository" | jq -sRr @uri)/releases/$release" ;;
  esac
  return $?
}

release_name() {
  platform=$1
  case "$platform" in
  github) printf '%s' 'name' ;;
  gitlab) printf '%s' 'name' ;;
  esac
}

release_body() {
  platform=$1
  case "$platform" in
  github) printf '%s' 'body' ;;
  gitlab) printf '%s' 'description' ;;
  esac
}

release_date() {
  platform=$1
  case "$platform" in
  github) printf '%s' 'publishedAt' ;;
  gitlab) printf '%s' 'released_at' ;;
  esac
}

download_release() {
  release=$1
  directory=$2
  case "$source_platform" in
  github) gh -R "$source_repository" release download "$release" -D "$directory" ;;
  gitlab) glab -R "$source_repository" release download "$release" -D "$directory" ;;
  esac
  return $?
}

sync_release() {
  release=$1

  if get_release "$target_platform" "$target_repository" "$release" >/dev/null 2>&1; then
    info "Release '$release' already exist on '$target_platform'"
    return 0
  fi

  info "Synchronizing '$release' on '$target_platform'"

  download=$(mktemp -d)
  if ! download_release "$release" "$download"; then
    error "Failed to download release '$release'"
    return 1
  fi
  rm "$download/"*"$release"* # remove potential archive assets

  release_data=$(get_release "$source_platform" "$source_repository" "$release") || {
    error "Failed to retrieve release '$release' from '$source_platform'"
    return 1
  }
  title=$(printf '%s' "$release_data" | jq -r '."'"$(release_name "$source_platform")"'"')
  description=$(printf '%s' "$release_data" | jq -r '."'"$(release_body "$source_platform")"'"')
  released_at=$(printf '%s' "$release_data" | jq -r '."'"$(release_date "$source_platform")"'"')

  case "$target_platform" in
  github) gh -R "$target_repository" release create "$release" "$download"/* --title "$title" --notes "$description" ;;
  gitlab) glab -R "$target_repository" release create "$release" "$download"/* --name "$title" --notes "$description" --released-at "$released_at" ;;
  esac
  return $?
}

#####################################################################
#
# Main
#
#####################################################################

main() {
  parse_arguments "$@" || return 1
  for cmd in mktemp jq tac tr; do required_command $cmd || return 1; done

  info "Starting synchronization from '$source_platform' to '$target_platform'"

  if [ -n "$version" ]; then
    sync_release "$version"
  else
    releases=$(get_releases "$source_platform" "$source_repository") || {
      error "Failed to retrieve releases"
      return 1
    }
    if [ "$(echo "$releases" | jq -r 'length')" -eq 0 ]; then
      info "No releases to synchronize"
      return 0
    fi
    for release in $(echo "$releases" | jq -r '.[].name' | tac | tr '\n' ' '); do
      sync_release "$release"
    done
  fi
}

main "$@"
