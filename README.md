# zsh-plugins <!-- omit in toc -->

<div align="center">

<!-- BEGIN_KICKR_BADGES -->
[![GitLab Issues](https://img.shields.io/gitlab/issues/open/kilianpaquier%2Fzsh-plugins?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge)](https://gitlab.com/kilianpaquier/zsh-plugins/-/work_items)
[![GitLab License](https://img.shields.io/gitlab/license/kilianpaquier%2Fzsh-plugins?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge)](https://gitlab.com/kilianpaquier/zsh-plugins/-/blob/HEAD/LICENSE)
[![GitLab CICD](https://img.shields.io/gitlab/pipeline-status/kilianpaquier%2Fzsh-plugins?gitlab_url=https%3A%2F%2Fgitlab.com&branch=main&style=for-the-badge)](https://gitlab.com/kilianpaquier/zsh-plugins/-/pipelines?ref=main)
[![Plumber Score](https://img.shields.io/endpoint?url=https%3A%2F%2Fscore.getplumber.io%2Fgitlab.com%2Fkilianpaquier%2Fzsh-plugins.json&style=for-the-badge)](https://score.getplumber.io/gitlab.com/kilianpaquier/zsh-plugins)
<!-- END_KICKR_BADGES -->

</div>

---

- [Install](#install)
  - [With zsh4humans](#with-zsh4humans)
  - [With oh-my-zsh](#with-oh-my-zsh)
- [Plugins](#plugins)
  - [completions](#completions)
  - [disk-cleanup](#disk-cleanup)
  - [gpg-edit](#gpg-edit)
  - [highlight-styles](#highlight-styles)
  - [history](#history)
  - [release-sync](#release-sync)

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

### completions

This plugin adds to `fpath` a new path `completions` which is `$XDG_CACHE_HOME/completions` or `$HOME/.cache/zsh/completions`
and then adds the completion file of each command listed in the `ZSH_COMPLETIONS` array
instead of evaluating it on every shell startup.

Each command starts with its tool name and files are refreshed every 7 days:

```zsh
ZSH_COMPLETIONS=(
  "chezmoi completion zsh"
  "just --completions zsh"
  "task --completion zsh"
)
```

Tools without a completion command go in `ZSH_COMPLETIONS_HELP`, completed from their `--help` output with zsh's `_gnu_generic`:

```zsh
ZSH_COMPLETIONS_HELP=(age age-keygen)
```

### disk-cleanup

This plugin adds a `disk-cleanup` command that clears dev-tool caches
and stale tools (Claude Code, Codex, Copilot, VSCode Server) versions, skipping anything not installed.

For more information, use `disk-cleanup --help` command.

### gpg-edit

This plugin adds a `gpg-edit` command to edit passphrase-encrypted (`gpg --symmetric`) files in place with your editor.

For more information, use `gpg-edit --help` command.

### highlight-styles

Removes all `underline` styles from [**zsh-syntax-highlighting**](https://github.com/zsh-users/zsh-syntax-highlighting) since I don't really like it.

### history

Sets zsh history options: extended timestamps, immediate write, sharing between sessions,
and duplicate or blank filtering.

### release-sync

This plugin adds a `release-sync` command to synchronize releases (artifacts included) between GitHub and GitLab repositories.

For more information, use `release-sync --help` command.
