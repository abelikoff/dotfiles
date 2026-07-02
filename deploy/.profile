# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Set XDG directories if needed

if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="$HOME/.config"

    if [ ! -d $XDG_CONFIG_HOME ]; then
        echo "ERROR: XDG_CONFIG_HOME ($XDG_CONFIG_HOME) does not exist" >&2
    fi
fi

if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"

    if [ ! -d $XDG_DATA_HOME ]; then
        echo "ERROR: XDG_DATA_HOME ($XDG_DATA_HOME) does not exist" >&2
    fi
fi

if [ -z "$XDG_STATE_HOME" ]; then
    export XDG_STATE_HOME="$HOME/.local/state"

    if [ ! -d $XDG_STATE_HOME ]; then
        echo "ERROR: XDG_STATE_HOME ($XDG_STATE_HOME) does not exist" >&2
    fi
fi

if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"

    if [ ! -d $XDG_CACHE_HOME ]; then
        echo "ERROR: XDG_CACHE_HOME ($XDG_CACHE_HOME) does not exist" >&2
    fi
fi


# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# Start SSH agent

SSHAGENT=/usr/bin/ssh-agent

if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    echo Starting ssh agent
    eval `$SSHAGENT -s`
    #trap "kill $SSH_AGENT_PID" 0
fi

# This needs to be in ~/.profile in order to be set in i3
export CALIBRE_USE_DARK_PALETTE=1
