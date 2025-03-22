#!/bin/zsh
# shellcheck disable=SC1071

git config --global --remove-section alias >/dev/null 2>&1 || true

git config --global alias.alias '!git config --get-regexp ^alias\. | sed -e s/^alias\.// -e s/\ /\ =\ /'
git config --global alias.amend 'commit --amend --no-edit'
git config --global alias.branches "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
git config --global alias.c 'commit -m'
git config --global alias.cp 'cherry-pick'
git config --global alias.current 'branch --show-current'
git config --global alias.upstream '!f() { git branch --set-upstream-to="${1-origin}/$(git current)" "$(git current)"; }; f'
git config --global alias.ls 'log --reverse'
git config --global alias.last 'ls -1 HEAD --stat'
git config --global alias.ll 'ls --oneline'
# shellcheck disable=SC2016
# git config --global alias.mad '!f() { git reset --hard ${1-origin/$(git current)}; }; f'
# shellcheck disable=SC2016
git config --global alias.mad 'reset --hard'
git config --global alias.n 'checkout -b'
git config --global alias.p 'push'
git config --global alias.pf 'push --force-with-lease'
# shellcheck disable=SC2016
git config --global alias.purge '!git fetch -p && for branch in $(git for-each-ref --format '\''%(refname) %(upstream:track)'\'' refs/heads | awk '\''$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'\''); do git branch -D $branch; done'
git config --global alias.r '!git fetch --all && git rebase'
git config --global alias.rename 'commit --amend'
git config --global alias.search '!git rev-list --all | xargs git grep -F'
git config --global alias.undo 'reset HEAD~1 --mixed'
git config --global alias.unstage 'reset HEAD --'
