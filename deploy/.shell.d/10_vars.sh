# -*- sh -*-

# shell variables


if [[ -d /var/lib/flatpak/exports/share ]] then
    #export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share
    export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:$XDG_DATA_DIRS
fi

if [[ -d $HOME/.local/share/flatpak/exports/share ]] then
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share
fi

export CALIBRE_USE_DARK_PALETTE=1

export HOMEBREW_NO_AUTO_UPDATE=1

# vi: ft=bash
