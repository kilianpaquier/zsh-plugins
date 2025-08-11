#!/bin/zsh
# shellcheck disable=SC1071

if (( ! $+commands[docker] )); then
  curl -fsSL https://get.docker.com | sh && dockerd-rootless-setuptool.sh install
fi
export DOCKER_HOST="unix:///run/user/$(id -u)/docker.sock"
