# zsh-plugins <!-- omit in toc -->

<p align="center">
  <img alt="GitHub Issues" src="https://img.shields.io/github/issues-raw/kilianpaquier/dotfiles?style=for-the-badge">
  <img alt="GitHub License" src="https://img.shields.io/github/license/kilianpaquier/dotfiles?style=for-the-badge">
</p>

---

- [Bash Aliases](#bash-aliases)
- [Docker Rootless](#docker-rootless)
- [Fzf](#fzf)
- [Git Aliases](#git-aliases)
- [Goenv](#goenv)
- [Highlight Styles](#highlight-styles)
- [Mise](#mise)
- [Misenv](#misenv)

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

## Misenv

Since mise plugin can install mise, it must be executed before the prompt is shown.
Which can adds latency if mise environment was computed at the same time.
As such, misenv plugin runs `msie activate zsh` and `mise completion zsh` with 
the help of [**evalcache**](https://github.com/mroth/evalcache) to have higher loading speed in subsequent shells.

Note that if **evalcache** plugin isn't provided, `eval` with a subshell execution will be made, which is slower in loading.
