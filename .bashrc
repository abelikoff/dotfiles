# ~/.bashrc: executed by bash(1) for non-login shells.

#if [ -f /etc/bashrc ]; then
#       . /etc/bashrc
#fi


# only execute for interactive sessions

[ -z "$PS1" ] && return

# history control

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# eternal history
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S  "

if [[ -z $PROMPT_COMMAND ]]; then
  PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}"'echo $USER $PWD \
                               "$(history 1)" >> ~/.bash_eternal_history'
fi


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set term to more colors

if [ "$TERM" = "xterm" ]; then
    if [ "$COLORTERM" = "gnome-terminal" ]; then
        TERM="gnome-256color"
    else
        TERM="xterm-256color"
    fi

    export TERM
fi

## set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color) color_prompt=yes;;
#esac
#
## uncomment for a colored prompt, if the terminal has the capability; turned
## off by default to not distract the user: the focus in a terminal window
## should be on the output of commands, not on the prompt
##force_color_prompt=yes
#
#if [ -n "$force_color_prompt" ]; then
#    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#        # We have color support; assume it's compliant with Ecma-48
#        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#        # a case would tend to support setf rather than setaf.)
#        color_prompt=yes
#    else
#        color_prompt=
#    fi
#fi
#
##if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt
#
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

elif [ $(uname) = "Darwin" ]; then
    alias ls='ls -G'
fi



# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


# paths

# JDK

if [ -d /opt/jdk ]; then
    PATH=$PATH:/opt/jdk/bin
    JAVA_HOME=/opt/jdk
    export PATH JAVA_HOME
fi


# Ruby

if [ -d $HOME/.rvm ]; then
    PATH=$PATH:$HOME/.rvm/bin
    export PATH
fi


# Heroku

if [ -d /usr/local/heroku ]; then
    PATH=$PATH:/usr/local/heroku/bin
    export PATH
fi


# MacPorts

if [ -x /opt/local/bin/port ]; then
    PATH=/opt/local/bin:/opt/local/sbin:$PATH
    export PATH
fi


# OPAM

if [ -d $HOME/.opam ]; then
  . $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
fi


# R

if [ -d $HOME/lib/R ]; then
  export R_LIBS_USER=$HOME/lib/R
fi


# TeX

if [[ $TEXINPUTS != */home/* ]]; then
    TEXINPUTS=".:$HOME/lib/latex:"
    export TEXINPUTS
fi


# shell control

ignoreeof=0

__user=$(whoami)

if [[ $__user != abel* ]]; then
    PS1="\[\e[0;31m\]${__user}@\[\e[0m\]"
else
    unset PS1
fi

unset __user
PS1="${PS1}\[\e[0;33m\]$(hostname -s | cut -c 1-4)\[\e[0m\]:\[\e[0;34m\]\W\[\e[0m\]\$ "
export PS1

umask 022


# useful settings

GREP_COLOR="43;30"
GREP_OPTIONS="--color=auto"
export EDITOR="vim"
export GREP_COLOR GREP_OPTIONS

if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
