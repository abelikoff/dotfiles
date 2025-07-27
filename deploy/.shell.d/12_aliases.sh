# shell functions and aliases (must be compatible with both bash and zsh)

# this is a hack for RPM building. /usr/sbin/Check (invoked by rpmbuild) is
# an sh script but it sources the environment and fails on bash/ksh function
# declarations. To avoid it, we don't load functions when run from rpmbuild
# directory

if [[ $PWD == */rpmbuild/* ]]; then
    return 0
fi

if [ "$(whoami)" = root ]; then
    alias rm='rm -i'

else
    if type rm | grep aliased >/dev/null; then
        unalias rm
    fi
fi

arv() {
    if [ -z "$1" ]; then
        echo "Usage: arv <archive>"
        return 1
    fi

    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) tar tvjf "$1" ;;
        *.tar.gz) tar tvzf "$1" ;;
        *.rar) unrar l "$1" ;;
        *.tar) tar tvf "$1" ;;
        *.tbz2) tar tvjf "$1" ;;
        *.tgz) tar tvzf "$1" ;;
        *.zip) unzip -l "$1" ;;
        *.7z) 7z l "$1" ;;
        *) echo "ERROR: unknown archive: '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

arx() {
    if [ -z "$1" ]; then
        echo "Usage: arx <archive>"
        return 1
    fi

    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "ERROR: unknown archive: '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

alias b='batcat'
alias cdd='cd ~/Downloads'
alias cdw='cd ~/work'
alias cln='rm *~'
alias cp='cp -i'
alias e='emacsclient -c'
alias et='emacsclient -t'

ev() {
    env | grep "$@"
}

alias fdd='find_dups -c "`pwd`/"'
alias gdw='git diff -w'

command -v glg >/dev/null && unalias glg

glg() {
    git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all "$@"
}

gls() {
    git log --stat "$@"
}

alias grep='grep --color'
alias ipinfo="curl -s https://ipinfo.io"

alias la='ls -a'
alias latr='ls -latr'
alias ll="$(which -a ls | grep -v alias | head -1) -lh --color=auto"
alias lrpm='rpm -qvlp'
alias m='less -i -r -M'
alias mv='mv -i'

if [ $(uname) = Linux ]; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi

alias po='popd'
alias pu='pushd'
#alias R='R --no-save -q'
alias tf='tail -f'

tfc() {
    tail -f "$@" | ccze -A
}

if [ $(uname) = Darwin ]; then
    alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
fi

if [[ -f /etc/redhat-release ]]; then
    alias rpm-scripts='rpm -q --queryformat "*** pre-install:\n%{PREIN}\n\n*** post-install:\n%{POSTUN}\n"'
    rpmgrep() { rpm -qa | grep "$@"; }
fi

xurls() {
    sed -e 's|>|>\n|g' -e 's|href=|\nhref=|gi' | grep -i href |
        sed -e 's|^href=.||gi' -e 's|[\"'"'"'].*||' | grep -i http
}

alias ytdf='yt-dlp --cookies-from-browser firefox'

alias auls='pactl list short sinks'

auset() {
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
eh() {
    local eh_file=$HOME/.bash_eternal_history

    if [[ ! -f $eh_file ]]; then
        echo "ERROR: no eternal history file ($eh_file)" >&2
        return
    fi

    if [[ "$1" == "-v" ]]; then
        egrep "$2" $eh_file |
            awk '{ $1 = $3 = $4 = $5 = ""; sub(home, "~", $2); $2 = "[" $2 "]"; print}' home=$HOME |
            sed 's/^ *//' | uniq
    else
        cut -d ' ' -f 8- $eh_file | egrep "$1" | sed 's/^ *//' | uniq
    fi
}

fbk() {
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

lc() {
    for x in $@; do
        mv $x $(echo $x | tr '[:upper:]' '[:lower:]')
    done
}

mkcd() {
    mkdir "$1"
    cd "$1"
}

psnam() { ps auxw | grep "$@" | grep -v grep; }
rpm_xtr() { rpm2cpio $1 | cpio -iv --make-directories; }

setapp() {
    if [[ -d $1 ]]; then
        export PATH=$1/bin:$PATH
        export LD_LIBRARY_PATH=$1/lib:$LD_LIBRARY_PATH
        export MANPATH=$1/man:$MANPATH
    else
        echo "ERROR: no such directory: $1"
    fi
}

setappi() {
    setapp $HOME/apps/$1
}

oo() {
    local cmd="xdg-open"

    if [ $(uname) = Darwin ]; then
        cmd="open"
    fi

    if [ $# -eq 0 ]; then
        $cmd . &
    else
        $cmd "$@" &
    fi
}

uc() {
    for x in $@; do
        mv $x $(echo $x | tr '[:lower:]' '[:upper:]')
    done
}

#vrz() { unzip -p "$@" | recode2 -ak; }
#vrzm() { unzip -p "$@" | recode2 -ak | m; }

#xtermname() { echo -en '\033]0;'$@'\007'; }
#xtl() { xterm -T "$1" -geometry 200x20 -e tail -f "$1"; }

#xtn() {
#    if [ "$1" != "" ]; then
#        xtermname "`hostname`: $1"
#    else
#        xtermname "`hostname`"
#    fi
#}
