if (( ! $+commands[docker] )); then
  curl -fsSL https://get.docker.com | sh && dockerd-rootless-setuptool.sh install
fi
export DOCKER_HOST="unix:///run/user/1000/docker.sock"
