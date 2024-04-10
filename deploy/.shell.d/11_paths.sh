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


# fzf

if [ -n "$ZSH_VERSION" ]; then
    if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
    fi

    if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
        source /usr/share/doc/fzf/examples/completion.zsh
    fi

elif [ -n "$BASH_VERSION" ]; then
    if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
        source /usr/share/doc/fzf/examples/key-bindings.bash
    fi

    if [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
        source /usr/share/doc/fzf/examples/completion.bash
    fi
fi


# Golang

if [ -d /usr/local/go ]; then
    PATH=/usr/local/go/bin:$PATH
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


# OPAM

if [ -d $HOME/.opam ]; then
  . $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
fi


# pyenv

if which pyenv > /dev/null 2>&1; then
    eval "$(pyenv init -)"
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
