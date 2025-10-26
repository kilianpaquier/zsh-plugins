# zsh-plugins <!-- omit in toc -->

<p align="center">
  <img alt="GitHub Release" src="https://img.shields.io/github/v/release/kilianpaquier/zsh-plugins?include_prereleases&sort=semver&style=for-the-badge">
  <img alt="GitHub Issues" src="https://img.shields.io/github/issues-raw/kilianpaquier/zsh-plugins?style=for-the-badge">
  <img alt="GitHub License" src="https://img.shields.io/github/license/kilianpaquier/zsh-plugins?style=for-the-badge">
  <img alt="GitHub Actions" src="https://img.shields.io/github/actions/workflow/status/kilianpaquier/zsh-plugins/integration.yml?style=for-the-badge">
</p>

---

- [Bash Aliases](#bash-aliases)
- [Bun Env](#bun-env)
- [Docker Rootless](#docker-rootless)
- [Fzf](#fzf)
- [Git Aliases](#git-aliases)
- [Goenv](#goenv)
- [Highlight Styles](#highlight-styles)
- [Mise](#mise)
- [Mise Activate](#mise-activate)
- [Mise Completion](#mise-completion)
- [Mise Shims](#mise-shims)
- [Terraform](#terraform)

## Bash Aliases

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

## Bun Env

This plugin adds `$HOME/.bun/bin` to global `PATH`.

Since `bun` is another package manager for `node` projects (instead of `npm`), it is possible to install globally tools with `bun` (like it is for `npm`), however if this path is not added to global `PATH`, then tools aren't found.

## Docker Rootless

Installs docker and setup rootless installation if not already installed.

In case Docker is already installed, then a simple export of `DOCKER_HOST` is made to `unix:///run/user/1000/docker.sock`.

## Fzf

Installs [**fzf**](https://github.com/junegunn/fzf) if not already installed.
I would recommend using [**fzf-tab**](https://github.com/Aloxaf/fzf-tab) plugin with this one to setup easily **fzf** 😉.

## Git Aliases

Setup various git aliases, you may check the plugin file for more information.

All those aliases are made inside `~/.gitconfig` and not as shell aliases.

## Goenv

Setup various Go environment variables, in particular to avoid `~/go` directory.

As such `GOPATH` is redirected to `~/.cache/go` alongside `imports`. Of course, `PATH` is updated with `GOBIN` path.

As for `GOLANGCI_LINT_CACHE` and `GOCACHE`, those two are defined to their default values when not provided.

## Highlight Styles

Removes all `underline` styles from [**zsh-syntax-highlighting**](https://github.com/zsh-users/zsh-syntax-highlighting) since I don't really like it.

## Mise

Installs [**mise**](https://mise.jdx.dev/) in case it doesn't exists
and adds a personal configuration file with tools not in default registry.

This personal configuration will not be generated (or removed) if `NO_MISE_CONFIG` environment variable is provided.

## Mise Activate

Since mise plugin can install mise, it must be executed before the prompt is shown.
As `mise activate zsh` can add latency to shell loading, this plugin is separated from installation one to avoid getting before prompt.

This plugin can use [**evalcache**](https://github.com/mroth/evalcache) to cache the result of `eval`
and gain some background time in subshell executions.

## Mise Completion

Since mise plugin can install mise, it must be executed before the prompt is shown.
As `mise completion zsh` can add latency to shell loading, this plugin is separated from installation one to avoid getting before prompt.

This plugin adds to `fpath` a new path `completions` which is `$XDG_CACHE_HOME/completions` or `$HOME/.cache/zsh/completions`
and then adds (only if it doesn't exist) mise completion file.

## Mise Shims

This plugin is an alternative one to `mise-activate` which use [shims](https://mise.jdx.dev/dev-tools/shims.html#shims-vs-path) instead of activate script.

When using this plugin, any new mise installation (a new tool) or tool removal must be followed of `mise reshim`
to create (or remove) its associated shim in `$HOME/.local/share/mise/shims`.

## Terraform

This plugin just aliases `terraform` binary to `tf` in case it is installed.
