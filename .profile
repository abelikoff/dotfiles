# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

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

# Fix Lenovo touchpad

if grep -i lenovo /sys/devices/virtual/dmi/id/sys_vendor > /dev/null 2>&1; then
    prop=$(xinput list-props 14 | awk -F'[()]' '$1 ~ /libinput Tapping Enabled[ \t]*$/ && $3 ~ /0$/ {print $2}')

    if [ -n $prop ]; then
        xinput set-prop 14 $prop 1
    fi

elif grep -i Dell /sys/devices/virtual/dmi/id/sys_vendor > /dev/null 2>&1; then
    prop=$(xinput list-props 10 | awk -F'[()]' '$1 ~ /libinput Tapping Enabled[ \t]*$/ && $3 ~ /0$/ {print $2}')

    if [ -n $prop ]; then
        xinput set-prop 10 $prop 1
    fi
fi



# This needs to be in ~/.profile in order to be set in i3
export CALIBRE_USE_DARK_PALETTE=1
