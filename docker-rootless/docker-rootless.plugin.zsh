#!/bin/zsh
# shellcheck disable=SC1071

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user/docker.service" ]; then
  export DOCKER_HOST="unix://${XDG_RUNTIME_DIR:-/run/user/$UID}/docker.sock"
fi
