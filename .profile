# $URL$ $Id$
#
# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

test -z "$PROFILEREAD" && . /etc/profile

# Most applications support several languages for their output.
# To make use of this feature, simply uncomment one of the lines below or
# add your own one (see /usr/share/locale/locale.alias for more codes)
#
#export LANG=de_DE@euro     # uncomment this line for German output
#export LANG=fr_FR@euro     # uncomment this line for French output
#export LANG=es_ES@euro     # uncomment this line for Spanish output


# Some people don't like fortune. If you uncomment the following lines,
# you will have a fortune each time you log in ;-)

#if [ -x /usr/bin/fortune ] ; then
#    echo
#    /usr/bin/fortune
#    echo
#fi

# Start SSH agent

SSHAGENT=/usr/bin/ssh-agent

if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    eval `$SSHAGENT -s`
    trap "kill $SSH_AGENT_PID" 0
fi

