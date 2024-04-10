#!/bin/bash

# set up configuration files

readonly program_name=${0##*/}
readonly program_version=2.0

shopt -s failglob               # fail upon non-matched globs
#set -e                          # abort on first error
set -u                          # disallow undefined variables
set -o pipefail                 # fail the pipe if one component fails


function run_command {
    if [[ -n $dry_run ]]; then
        notice WILL RUN: $@

    elif [[ -n $do_prompt ]]; then
        echo -n "Run command [" $@ "]? (y/N) "
        read response

        if [[ $response == "y" || $response == "Y" ]]; then
            $@
        fi
    else
        $@
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
            verbose "$file is already set up correctly - skipping."
            return
        fi
    fi

    if [[ -e $fname ]]; then
        if diff -w $fname $src_file > /dev/null 2>&1; then
            verbose "$file is same as target - not backing up" >&2
            run_command rm -f $fname
        else
            run_command mkdir -p $backup_dir
            notice "$file will be saved to $BACKUP_DIR" >&2
            run_command mv $fname $backup_dir/
        fi
    fi

    verbose "$fname -> $src_file"
    run_command ln -s $src_file .
}


function usage {
    echo "
    Usage:  $program_name  [options]

$program_name sets up configuration files


$program_name supports the following options:

    -f                        - perform changes (default: dry run)
    -i                        - prompt interactively for each change

    -v                        - verbose operation
    -V                        - display program version
    -h                        - display this message

"
}


verbose() {
    if [[ -n $verbose_mode ]]; then
        echo "$@"
    fi
}


debug() {
    if [[ -n $debug_mode ]]; then
        echo "$@"
    fi
}


error() {
    echo -e "${color_red}ERROR:" "$@" "${color_none}" >&2
}


fatal() {
    error "$@"
    exit 1
}


warning() {
    echo -e "${color_yellow}WARNING:" "$@" "${color_none}" >&2
}


notice() {
    echo -e "${color_cyan}$@" "${color_none}" >&2
}


cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}


setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    color_none='[0m' color_red='[0;31m' color_green='[0;32m'
    color_orange='[0;33m' color_blue='[0;34m' color_purple='[0;35m'
    color_cyan='[0;36m' color_yellow='[1;33m'
  else
    color_none='' color_red='' color_green='' color_orange='' color_blue=''
    color_purple='' color_cyan='' color_yellow=''
  fi

  readonly color_none color_red color_green color_orange color_blue \
    color_purple color_cyan color_yellow
}


setup_colors


# parse options

verbose_mode=""
do_prompt=""
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

        V) echo "$program_name $program_version"
           exit 0
           ;;

        v) verbose_mode=1
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
readonly SRC_DIR=$VC_TOP/deploy

find $SRC_DIR -type f | while read full_path; do
    filename="$(basename $full_path)"
    dir="$(dirname $full_path)"
    dir=${dir##$SRC_DIR}
    dir=${dir#/}

    if [[ -n $dir ]]; then
        install_dir="$HOME/$dir"
        path_back=$(echo $dir | sed 's|[^/][^/]*|..|g')
        vc_dir=${path_back}/${VC_TOP}/deploy/$dir
    else
        install_dir=$HOME
        vc_dir=$VC_TOP/deploy
    fi

    install_file $filename $install_dir $vc_dir $BACKUP_DIR
done

if [[ ! -d ~/.vim//bundle/Vundle.vim ]]; then
    run_command git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

if [[ ! -d ~/.oh-my-zsh ]]; then
    run_command sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ ! -d ~/.tmux/plugins ]]; then
    run_command git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
