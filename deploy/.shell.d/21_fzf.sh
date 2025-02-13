# fzf setup

if [ -n "$(which fzf)" ]; then
    if [ -n "$ZSH_VERSION" ]; then
        source <(fzf --zsh)
    elif [ -n "$BASH_VERSION" ]; then
        eval "$(fzf --bash)"
    fi
fi
