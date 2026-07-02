# # Better shell tools

# Eza (better ls)

if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons'
    alias ll='eza -lh --icons --git'
    alias la='eza -lah --icons --git'
    alias tree="eza --tree --icons"

    if [ -n "$ZSH_VERSION" ]; then
        compdef eza=ls
    fi
fi

# Bat (better cat)

if command -v bat >/dev/null 2>&1; then
    alias cat='bat'

elif command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
    alias cat='batcat'
fi

# Fd (better find)

if command -v fdfind >/dev/null 2>&1; then
    alias fd='fdfind'
fi

