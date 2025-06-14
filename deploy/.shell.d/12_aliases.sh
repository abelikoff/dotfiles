# -*- sh -*-

# shell aliases

if [ "$(whoami)" = root ]; then
    alias rm='rm -i'

else
    if type rm | grep aliased > /dev/null; then
        unalias rm
    fi
fi

alias b='batcat'
alias cdd='cd ~/Downloads'
alias cdw='cd ~/work'
alias cln='rm *~'
alias cp='cp -i'
alias e='emacsclient -c'
alias et='emacsclient -t'

ev () {
    env | grep "$@"
}

alias fdd='find_dups -c "`pwd`/"'
alias gdw='git diff -w'

command -v glg > /dev/null && unalias glg

glg () {
    git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all "$@"
}

gls () {
    git log --stat "$@"
}

alias grep='grep --color'
alias hn=hostname
alias la='ls -a'
alias latr='ls -latr'
alias ll='/bin/ls -lh --color=auto'
alias lrpm='rpm -qvlp'
alias m='less -i -r -M'
alias myip="curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
alias mv='mv -i'

if [ $(uname) = Linux ]; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi

alias po='popd'
alias pu='pushd'
alias R='R --no-save -q'
alias tf='tail -f'

tfc () {
    tail -f "$@" | ccze -A
}

if [ $(uname) = Darwin ]; then
    alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
    alias op='open .'
else
    alias op='xdg-open . &'
fi


if [[ -f /etc/redhat-release ]]; then
    alias rpm-scripts='rpm -q --queryformat "*** pre-install:\n%{PREIN}\n\n*** post-install:\n%{POSTUN}\n"'
    alias vi='vim'
fi

function xurls {
    sed -e 's|>|>\n|g' -e 's|href=|\nhref=|gi' | grep -i href | \
        sed -e 's|^href=.||gi' -e 's|[\"'"'"'].*||' | grep -i http
}

alias ytdf='yt-dlp --cookies-from-browser firefox'


# this is a hack for RPM building. /usr/sbin/Check (invoked by rpmbuild) is
# an sh script but it sources the environment and fails on bash/ksh function
# declarations. To avoid it, we don't load functions when run from rpmbuild
# directory

if [[ $PWD != */rpmbuild/* ]]; then

    alias auls='pactl list short sinks'

    function auset {
        pactl set-default-sink $(pactl list short sinks | grep "$1" | awk '{print $1}')
    }

    function cdf {
        typeset fpath short_path

        fpath=$(find ~/devel -name "$1" | egrep -v '(/.git|/venvs/)' | head -1)

        if [[ -f $fpath ]]; then
            fpath=$(dirname $fpath)
            short_path="~${fpath#$HOME}"
        fi

        if [[ -d $fpath ]]; then
            echo "Changing to $(tput setaf 2)$short_path$(tput sgr 0)"
            cd $fpath
        fi
    }

    # eternal history search
    function eh {
        local eh_file=$HOME/.bash_eternal_history

        if [[ ! -f $eh_file ]]; then
            echo "ERROR: no eternal history file ($eh_file)" >&2
            return
        fi

        if [[ "$1" == "-v" ]]; then
            egrep "$2" $eh_file | \
              awk '{ $1 = $3 = $4 = $5 = ""; sub(home, "~", $2); $2 = "[" $2 "]"; print}' home=$HOME | \
              sed 's/^ *//' | uniq
        else
            cut -d ' ' -f 8- $eh_file | egrep "$1" | sed 's/^ *//' | uniq
        fi
    }

    function fbk {
        local file
        local basename
        local ext
        local new_name
        local rc=0

        for file in "$@"; do
            basename="${file%.*}"
            ext="${file##*.}"
            new_name="${basename}_$(date +%Y%m%d-%H%M).$ext"
            mv -v "$file" "$new_name" || rc=1
        done

        return $rc
    }

    function lc {
        for x in $@ ; do
            mv $x `echo $x | tr '[:upper:]' '[:lower:]'`
        done
    }

    function mkcd { mkdir "$1"; cd "$1" ; }
    function psnam { ps auxw | grep "$@" | grep -v grep ; }
    function rpm-xtr { rpm2cpio $1 | cpio -iv --make-directories ; }
    function rpmgrep { rpm -qa | grep "$@" ; }

    function setapp {
        if [[ -d $1 ]]; then
            export PATH=$1/bin:$PATH
            export LD_LIBRARY_PATH=$1/lib:$LD_LIBRARY_PATH
            export MANPATH=$1/man:$MANPATH
        else
            echo "ERROR: no such directory: $1"
        fi
    }

    function setappi {
        setapp $HOME/apps/$1
    }

    function oo {
        if [ $# -eq 0 ]; then
            xdg-open . &
        else
            xdg-open "$@" &
        fi
    }

    function uc {
        for x in $@ ; do
            mv $x `echo $x | tr '[:lower:]' '[:upper:]'`
        done
    }

    function vrz { unzip -p "$@" | recode2 -ak; }
    function vrzm { unzip -p "$@" | recode2 -ak | m; }

    function xtermname { echo -en '\033]0;'$@'\007'; }
    function xtl { xterm -T "$1" -geometry 200x20 -e tail -f "$1"; }

    function xtn {
        if [ "$1" != "" ]; then
            xtermname "`hostname`: $1"
        else
            xtermname "`hostname`"
        fi
    }

    function ztv  {
        typeset file

        for file in "$@"; do
            case "$file" in
                *.bz2) bunzip2 -c < "$file" ;;
                *.[Zz]) zcat "$file" ;;
                *) gunzip -c "$file" ;;
            esac | tar tvf -
        done
    }

    function ztx  {
        typeset file

        for file in "$@"; do
            case "$file" in
                *.bz2) bunzip2 -c < "$file" ;;
                *.[Zz]) zcat "$file" ;;
                *) gunzip -c "$file" ;;
            esac | tar xf -
        done
    }

fi

# vi: ft=bash
