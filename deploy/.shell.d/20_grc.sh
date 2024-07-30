GRC=$(which grc)
echo here

if [ "$TERM" != dumb ] && [ -n "$GRC" ]; then
    alias grc_colorize="$GRC -es --colour=auto"
    alias configure='grc_colorize ./configure'
    alias diff='grc_colorize diff'
    alias make='grc_colorize make'
    alias gcc='grc_colorize gcc'
    alias g++='grc_colorize g++'
    alias as='grc_colorize as'
    alias gas='grc_colorize gas'
    alias ld='grc_colorize ld'
    alias netstat='grc_colorize netstat'
    alias ping='grc_colorize ping'
    alias traceroute='grc_colorize /usr/sbin/traceroute'
    alias head='grc_colorize head'
    alias tail='grc_colorize tail'
    alias dig='grc_colorize dig'
    alias mount='grc_colorize mount'
    alias ps='grc_colorize ps'
    alias mtr='grc_colorize mtr'
    alias df='grc_colorize df'
fi

