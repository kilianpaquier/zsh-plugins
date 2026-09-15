# zsh-plugins <!-- omit in toc -->

<div align="center">
  <img alt="GitLab Release" src="https://img.shields.io/gitlab/v/release/kilianpaquier%2Fzsh-plugins?gitlab_url=https%3A%2F%2Fgitlab.com&include_prereleases&sort=semver&style=for-the-badge">
  <img alt="GitLab Issues" src="https://img.shields.io/gitlab/issues/open/kilianpaquier%2Fzsh-plugins?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab License" src="https://img.shields.io/gitlab/license/kilianpaquier%2Fzsh-plugins?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab CICD" src="https://img.shields.io/gitlab/pipeline-status/kilianpaquier%2Fzsh-plugins?gitlab_url=https%3A%2F%2Fgitlab.com&branch=main&style=for-the-badge">
</div>

---

- [Install](#install)
  - [With zsh4humans](#with-zsh4humans)
  - [With oh-my-zsh](#with-oh-my-zsh)
- [Plugins](#plugins)
  - [Chezmoi completion](#chezmoi-completion)
  - [Disk Cleanup](#disk-cleanup)
  - [Docker Rootless](#docker-rootless)
  - [gitlab-ci-local completion](#gitlab-ci-local-completion)
  - [Highlight Styles](#highlight-styles)
  - [History](#history)
  - [Just completion](#just-completion)
  - [Mise completion](#mise-completion)
  - [Release Sync](#release-sync)
  - [Task Completion](#task-completion)

## Install

Every plugin lives in its own directory with a `<name>/<name>.plugin.zsh` entrypoint,
so any zsh plugin manager able to source a subdirectory of a repository works.

The repository is hosted on [GitLab](https://gitlab.com/kilianpaquier/zsh-plugins)
and mirrored on [GitHub](https://github.com/kilianpaquier/zsh-plugins).

### With zsh4humans

`z4h install` clones from GitHub, and `z4h load` takes the path of a plugin directory inside the repository.

Plugins loaded before `z4h init` are sourced synchronously (needed for `history`, since its options must be set before the prompt).
Plugins loaded after are sourced asynchronously.

```zsh
# ~/.zshrc

repos=(
  kilianpaquier/zsh-plugins
)
for repo in $repos; do z4h install "$repo" || return; done
unset repo repos

plugins=(
  kilianpaquier/zsh-plugins/history
)
for plugin in $plugins; do z4h load "$plugin"; done
unset plugin plugins

z4h init || return

# pick any plugins from the list below (see "Plugins" section)
plugins=(
  kilianpaquier/zsh-plugins/highlight-styles
  kilianpaquier/zsh-plugins/release-sync
)
for plugin in $plugins; do z4h load "$plugin"; done
unset plugin plugins
```

### With oh-my-zsh

Clone the repository once, then symlink the wanted plugins into `$ZSH_CUSTOM/plugins`.

```sh
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

git clone --depth 1 https://github.com/kilianpaquier/zsh-plugins.git "$ZSH_CUSTOM/zsh-plugins"
# pick any plugins from the list below (see "Plugins" section)
for plugin in history highlight-styles release-sync; do
  ln -sfn "$ZSH_CUSTOM/zsh-plugins/$plugin" "$ZSH_CUSTOM/plugins/$plugin"
done
```

```zsh
# ~/.zshrc

plugins=(
  history
  highlight-styles
  release-sync
)

source "$ZSH/oh-my-zsh.sh"
```

Update to another version with:

```sh
git -C "$ZSH_CUSTOM/zsh-plugins" fetch --tags --depth 1 origin v0.2.0
git -C "$ZSH_CUSTOM/zsh-plugins" checkout v0.2.0
```

## Plugins

### Chezmoi completion

This plugin adds to `fpath` a new path `completions` which is `$XDG_CACHE_HOME/completions` or `$HOME/.cache/zsh/completions`
and then adds (only if it doesn't exist) `chezmoi` completion file, generated once with `chezmoi completion zsh`
instead of evaluating it on every shell startup.

### Disk Cleanup

This plugin adds a `disk-cleanup` command that clears dev-tool caches
and stale tools (Claude Code, Codex, Copilot, VSCode Server) versions, skipping anything not installed.

### Docker Rootless

Exports `DOCKER_HOST` to `unix://$XDG_RUNTIME_DIR/docker.sock` or `unix:///run/user/$UID/docker.sock`
when a rootless docker installation is detected.

Detection is the presence of the systemd user unit created by `dockerd-rootless-setuptool.sh install`,
in `$XDG_CONFIG_HOME/systemd/user/docker.service` or `$HOME/.config/systemd/user/docker.service`.
It relies on a single file check to keep shell startup free of any command execution.

This plugin installs nothing, docker itself must be set up beforehand.

### gitlab-ci-local completion

This plugin adds to `fpath` a new path `completions` which is `$XDG_CACHE_HOME/completions` or `$HOME/.cache/zsh/completions`
and then adds (only if it doesn't exist) `gitlab-ci-local` completion file, generated once with `gitlab-ci-local --completion`
instead of evaluating it on every shell startup.

### Highlight Styles

Removes all `underline` styles from [**zsh-syntax-highlighting**](https://github.com/zsh-users/zsh-syntax-highlighting) since I don't really like it.

### History

Sets zsh history options: extended timestamps, immediate write, sharing between sessions,
and duplicate or blank filtering.

### Just completion

This plugin adds to `fpath` a new path `completions` which is `$XDG_CACHE_HOME/completions` or `$HOME/.cache/zsh/completions`
and then adds (only if it doesn't exist) `just` completion file, generated once with `just --completions zsh`
instead of evaluating it on every shell startup.

### Mise completion

This plugin adds to `fpath` a new path `completions` which is `$XDG_CACHE_HOME/completions` or `$HOME/.cache/zsh/completions`
and then adds (only if it doesn't exist) `mise` completion file, generated once with `mise completion zsh`
instead of evaluating it on every shell startup.

### Release Sync

This plugin adds a `release-sync` command to synchronize releases (artifacts included) between GitHub and GitLab repositories.
For more information, use `release-sync --help` command.

### Task Completion

This plugin adds to `fpath` a new path `completions` which is `$XDG_CACHE_HOME/completions` or `$HOME/.cache/zsh/completions`
and then adds (only if it doesn't exist) `task` completion file, generated once with `task --completion zsh`
instead of evaluating it on every shell startup.
