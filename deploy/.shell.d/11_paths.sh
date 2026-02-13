# -*- sh -*-

# path setup for shells

if [ -d $HOME/bin ]; then
    PATH=$HOME/bin:$PATH
fi


# most used paths

CDPATH=$HOME:$HOME/devel:$HOME/devel/bitbucket:$HOME/devel/git:$HOME/devel/github

if [ -d /var/www/sites ]; then
    CDPATH=$CDPATH:/var/www/sites
elif [ -d /var/www/html ]; then
    CDPATH=$CDPATH:/var/www/html
fi

export CDPATH


if [ -d $HOME/.local/bin ]; then
    PATH=$PATH:$HOME/.local/bin
fi


# Antigravity

if [ -d $HOME/.antigravity/antigravity/bin ]; then
    PATH=$PATH:$HOME/.antigravity/antigravity/bin
fi


# Google cloud SDK

if [ -d $HOME/devel/tools/google-cloud-sdk ]; then
    if [ -n "$ZSH_VERSION" ]; then
        source $HOME/devel/tools/google-cloud-sdk/path.zsh.inc
        source $HOME/devel/tools/google-cloud-sdk/completion.zsh.inc
    elif [ -n "$BASH_VERSION" ]; then
        source $HOME/devel/tools/google-cloud-sdk/path.bash.inc
        source $HOME/devel/tools/google-cloud-sdk/completion.bash.inc
    fi
fi


# Flutter

for dir in $HOME/tools/flutter $HOME/snap/flutter/common/flutter; do
    if [ -d $dir ]; then
        PATH=$PATH:$dir/bin
        break
    fi
done


# Golang

if [ -d /opt/go ]; then
    PATH=/opt/go/bin:$PATH
fi

if [ -d $HOME/tools/go ]; then
    export GOPATH=$HOME/tools/go
    PATH=$PATH:$GOPATH/bin
fi


# Homebrew

if [ -d /opt/homebrew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d $HOME/tools/brew ]; then
    PATH=$HOME/tools/brew/opt/python/libexec/bin:$HOME/tools/brew/bin:$PATH
fi


# Nix

if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi


# pyenv

if which pyenv > /dev/null 2>&1; then
    eval "$(pyenv init -)"
fi


# Pipx

if [[ -d $HOME/.local/bin ]]; then
    PATH=$PATH:$HOME/.local/bin
fi


# R

if [ -d $HOME/lib/R ]; then
  export R_LIBS_USER=$HOME/lib/R
fi

export R_HISTSIZE=5000


# Rust

if [ -d $HOME/.cargo ]; then
    source $HOME/.cargo/env
fi


# TeX

if [[ $TEXINPUTS != */home/* ]]; then
    TEXINPUTS=".:$HOME/lib/latex:"
    export TEXINPUTS
fi


if [ -n "$ZSH_VERSION" ]; then
    if [ -f ~/.zshrc.local ]; then
        . ~/.zshrc.local
    fi
elif [ -n "$BASH_VERSION" ]; then
    if [ -f ~/.bashrc.local ]; then
        . ~/.bashrc.local
    fi
fi

export PATH

# vi: ft=bash
