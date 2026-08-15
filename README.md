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
  - [Bash Aliases](#bash-aliases)
  - [Bun Env](#bun-env)
  - [Docker Rootless](#docker-rootless)
  - [Fzf](#fzf)
  - [Git Aliases](#git-aliases)
  - [Goenv](#goenv)
  - [Highlight Styles](#highlight-styles)
  - [History](#history)
  - [Java LSP](#java-lsp)
  - [Just Completion](#just-completion)
  - [Mise](#mise)
  - [Mise Completion](#mise-completion)
  - [Mise Shims](#mise-shims)
  - [No Proxy](#no-proxy)
  - [Release Sync](#release-sync)
  - [Task Completion](#task-completion)
  - [Terraform](#terraform)

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
  kilianpaquier/zsh-plugins@v0.1.0
)
for repo in $repos; do z4h install "$repo" || return; done
unset repo repos

plugins=(
  kilianpaquier/zsh-plugins/history
)
for plugin in $plugins; do z4h load "$plugin"; done
unset plugin plugins

z4h init || return

plugins=(
  kilianpaquier/zsh-plugins/highlight-styles
  kilianpaquier/zsh-plugins/just-completion
  kilianpaquier/zsh-plugins/mise-completion
  kilianpaquier/zsh-plugins/release-sync
  kilianpaquier/zsh-plugins/task-completion
)
for plugin in $plugins; do z4h load "$plugin"; done
unset plugin plugins
```

### With oh-my-zsh

Clone the repository once, then symlink the wanted plugins into `$ZSH_CUSTOM/plugins`.

```sh
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

git clone --branch v0.1.0 --depth 1 https://github.com/kilianpaquier/zsh-plugins.git "$ZSH_CUSTOM/zsh-plugins"
for plugin in history highlight-styles just-completion mise-completion release-sync task-completion; do
  ln -sfn "$ZSH_CUSTOM/zsh-plugins/$plugin" "$ZSH_CUSTOM/plugins/$plugin"
done
```

```zsh
# ~/.zshrc

plugins=(
  history
  highlight-styles
  just-completion
  mise-completion
  release-sync
  task-completion
)

source "$ZSH/oh-my-zsh.sh"
```

Update to another version with:

```sh
git -C "$ZSH_CUSTOM/zsh-plugins" fetch --tags --depth 1 origin v0.2.0
git -C "$ZSH_CUSTOM/zsh-plugins" checkout v0.2.0
```

## Plugins

### Bash Aliases

Defines various aliases that can be found in `~/.bashrc` by default:

```sh
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lart'
alias l='ls -CF'
```

### Bun Env

This plugin adds `$HOME/.bun/bin` to global `PATH`.

Since `bun` is another package manager for `node` projects (instead of `npm`), it is possible to install globally tools with `bun` (like it is for `npm`), however if this path is not added to global `PATH`, then tools aren't found.

### Docker Rootless

Installs docker and setup rootless installation if not already installed.

In case Docker is already installed, then a simple export of `DOCKER_HOST` is made to `unix:///run/user/1000/docker.sock`.

### Fzf

Installs [**fzf**](https://github.com/junegunn/fzf) if not already installed.
I would recommend using [**fzf-tab**](https://github.com/Aloxaf/fzf-tab) plugin with this one to setup easily **fzf** 😉.

### Git Aliases

Setup various git aliases, you may check the plugin file for more information.

All those aliases are made inside `~/.gitconfig` and not as shell aliases.

### Goenv

Setup various Go environment variables, in particular to avoid `~/go` directory.

As such `GOPATH` is redirected to `~/.cache/go` alongside `imports`. Of course, `PATH` is updated with `GOBIN` path.

As for `GOLANGCI_LINT_CACHE` and `GOCACHE`, those two are defined to their default values when not provided.

### Highlight Styles

Removes all `underline` styles from [**zsh-syntax-highlighting**](https://github.com/zsh-users/zsh-syntax-highlighting) since I don't really like it.

### History

Sets zsh history options: extended timestamps, immediate write, sharing between sessions,
and duplicate or blank filtering.

### Java LSP

Installs `jdtls` (Eclipse JDT Language Server) in `$XDG_DATA_HOME/jdtls` or `$HOME/.local/share/jdtls`.
This Java Language Server can be easily used by AI agents to easily access source code instead of using terminal commands
such as `grep`.

### Just Completion

This plugin adds to `fpath` a new path `completions` which is `$XDG_CACHE_HOME/completions` or `$HOME/.cache/zsh/completions`
and then adds (only if it doesn't exist) `just` completion file, generated once with `just --completions zsh`
instead of evaluating it on every shell startup.

### Mise

Installs [**mise**](https://mise.jdx.dev/) in case it doesn't exists
and adds a personal configuration file with tools not in default registry.

This personal configuration will not be generated (or removed) if `NO_MISE_CONFIG` environment variable is provided.

### Mise Completion

Since mise plugin can install mise, it must be executed before the prompt is shown.
As `mise completion zsh` can add latency to shell loading, this plugin is separated from installation one to avoid getting before prompt.

This plugin adds to `fpath` a new path `completions` which is `$XDG_CACHE_HOME/completions` or `$HOME/.cache/zsh/completions`
and then adds (only if it doesn't exist) mise completion file.

### Mise Shims

This plugin activates `mise` through the [shims](https://mise.jdx.dev/dev-tools/shims.html#shims-vs-path) instead of `activate` script.

When using this plugin, any new mise installation (a new tool) or tool removal must be followed of `mise reshim`
to create (or remove) its associated shim in `$HOME/.local/share/mise/shims`.

### No Proxy

This plugin removes all `HTTP_PROXY`, `HTTPS_PROXY`, `http_proxy` and `https_proxy` environment variables to avoid any proxy configuration.

### Release Sync

This plugin adds a `release-sync` command to synchronize releases (artifacts included) between GitHub and GitLab repositories.
For more information, use `release-sync --help` command.

### Task Completion

This plugin adds to `fpath` a new path `completions` which is `$XDG_CACHE_HOME/completions` or `$HOME/.cache/zsh/completions`
and then adds (only if it doesn't exist) `task` completion file, generated once with `task --completion zsh`
instead of evaluating it on every shell startup.

### Terraform

This plugin just aliases `terraform` binary to `tf` in case it is installed.
