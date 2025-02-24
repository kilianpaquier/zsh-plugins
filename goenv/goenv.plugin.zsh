#!/bin/zsh
# shellcheck disable=SC1071

export GOPATH="$HOME/.cache/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

export GOCACHE="$HOME/.cache/go-build"
export GOLANGCI_LINT_CACHE="$HOME/.cache/golangci-lint"
