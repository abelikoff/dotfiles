# fzf setup

if command -v fzf-share >/dev/null; then
    if [ -n "$BASH_VERSION" ]; then
        source "$(fzf-share)/key-bindings.bash"
        source "$(fzf-share)/completion.bash"

    elif [ -n "$ZSH_VERSION" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
    fi

elif [[ -d /usr/share/doc/fzf/examples ]]; then
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

elif [ -n "$(which fzf)" ]; then # old way
    if [ -n "$ZSH_VERSION" ]; then
        source <(fzf --zsh)
    elif [ -n "$BASH_VERSION" ]; then
        eval "$(fzf --bash)"
    fi
fi

export FZF_DEFAULT_OPTS='--height 20% --border'
