# fzf setup

which fzf >/dev/null 2>&1 || return

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

else # old way
    if [ -n "$ZSH_VERSION" ]; then
        source <(fzf --zsh)
    elif [ -n "$BASH_VERSION" ]; then
        eval "$(fzf --bash)"
    fi
fi

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse
       --bind=tab:down,shift-tab:up
       --color=fg:#f8f8f2,bg:-1,hl:#8be9fd,fg+:#f8f8f2,bg+:#44475a,hl+:#ff79c6,info:#bd93f9,prompt:#50fa7b,pointer:#ff79c6,marker:#ffb86c,spinner:#ff79c6,header:#6272a4"
