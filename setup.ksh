#!/bin/ksh

# set up configuration files


CONF_FILES=".bash_aliases
            .bashrc
            .dircolors
            .emacs
            .gitconfig
            .inputrc
            .ocamlinit
            .profile
            .pylintrc
            .screenrc
            .tmux.conf
            .vim
            .vimrc
            .wgetrc
            .Xresources
            lib/latex/mathmacros.sty
            lib/elisp/color-theme-solarized.el
            lib/elisp/monokai-theme.el"

prog=${0##*/}
version=1.0


function run_command {
    if [[ -n $dry_run ]]; then
        echo WILL RUN: $@

    elif [[ -n $do_prompt ]]; then
        echo -n "Run command [" $@ "]? (y/N) "
        read response

        if [[ $response == "y" || $response == "Y" ]]; then
            $@
        fi
    fi
}


function install_file {
    file="$1"                   # subpath under $vc_dir
    tgt_dir="$2"                # where to install the link
    vc_dir="$3"                 # version control top directory
    backup_dir="$4"             # backup directory

    src_file=$vc_dir/$file
    fname=$(basename $file)

    if [[ ! -d $tgt_dir ]]; then
        run_command mkdir -p $tgt_dir

        if [[ -n run_command ]]; then
            run_command cd $tgt_dir
            run_command ln -s $src_file .
            return
        fi
    fi

    cd $tgt_dir || return

    if [[ -L $fname ]]; then
        old_src_file="$(readlink $fname)"

        if [[ $src_file == $old_src_file ]]; then
            verbose "NOTICE: $file is already set up correctly - skipping."
            return
        fi
    fi

    if [[ -e $fname ]]; then
        if diff -w $fname $src_file > /dev/null; then
            print -u2 "NOTICE: $file is same as target - not backing up"
            run_command rm -f $fname
        else
            run_command mkdir -p $backup_dir
            print -u2 "NOTICE: $file will be saved to $BACKUP_DIR"
            run_command mv $fname $backup_dir/
        fi
    fi

    verbose "$fname -> $src_file"
    run_command ln -s $src_file .
}


function usage {
    print "
    Usage:  $prog  [options]

$prog sets up configuration files


$prog supports the following options:

    -f                        - perform changes (default: dry run)
    -i                        - prompt interactively for each change

    -v                        - verbose operation
    -V                        - display program version
    -h                        - display this message

"
}


function debug {
    [[ -n $do_debug ]] && print "DEBUG: " $@
}


function verbose {
    [[ -n $do_verbose ]] && print $@
}


function error {
    print -u2 "$prog: ERROR:" $@
}


function fatal {
    error $@
    exit 1
}


function warning {
    print -u2 "$prog: WARNING:" $@
}


# parse options

unset do_verbose do_prompt
dry_run=1

while getopts ":fhiVv" opt ; do
    case $opt in
        f) unset dry_run
           ;;

        h) usage
           exit 0
           ;;

        i) do_prompt=1
           unset dry_run
           ;;

        V) print "$prog $version"
           exit 0
           ;;

        v) do_verbose=1
           ;;

        :) fatal "option '-$OPTARG' requires an argument"
           ;;

        \?) error "unknown option: '-$OPTARG'"
            usage
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

VC_TOP=$(dirname $0)

if [[ $VC_TOP == "." ]]; then
    VC_TOP=$(pwd)
fi

cd ~ || exit 1
VC_TOP=${VC_TOP##./}            # remove leading ./
VC_TOP=${VC_TOP##$(pwd)/}       # change to relative path
BACKUP_DIR=~/CONFIG_BACKUP.$(date +"%Y%m%d-%H%M%S")

for file in $CONF_FILES; do
    if [[ $file == */* ]]; then     # subdir
        install_dir=$HOME/$(dirname $file)
        path_back=$(echo $(dirname $file) | sed 's|[^/][^/]*|..|g')
        vc_dir=${path_back}/${VC_TOP}
    else
        install_dir=$HOME
        vc_dir=$VC_TOP
    fi

    install_file $file $install_dir $vc_dir $BACKUP_DIR
done
