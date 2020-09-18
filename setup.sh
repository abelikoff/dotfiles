#!/bin/bash

# set up configuration files


CONF_FILES=".astylerc
            .bashrc
            .dircolors
            .emacs
            .gitconfig
            .inputrc
            .i3
            .i3-workspace
            .i3blocks.conf
            .ocamlinit
            .profile
            .pylintrc
            .Rprofile
            .screenrc
            .shell_aliases
            .shell_paths
            .shell_vars
            .tidyrc
            .tmux.conf
            .tmux.dracula.sh
            .vimrc
            .xscreensaver
            .Xresources
            .zshrc
            .config/rofi/config
            bin/i3_local_setup.sh
            bin/i3_setxkb.sh
            bin/toggle_touchpad
            lib/latex/mathmacros.sty"

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
            verbose "NOTICE: $file is already set up correctly - skipping."
            return
        fi
    fi

    if [[ -e $fname ]]; then
        if diff -w $fname $src_file > /dev/null; then
            echo "NOTICE: $file is same as target - not backing up" >&2
            run_command rm -f $fname
        else
            run_command mkdir -p $backup_dir
            echo "NOTICE: $file will be saved to $BACKUP_DIR" >&2
            run_command mv $fname $backup_dir/
        fi
    fi

    verbose "$fname -> $src_file"
    run_command ln -s $src_file .
}


function usage {
    echo "
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
    [[ -n $do_debug ]] && echo "DEBUG: " $@
}


function verbose {
    [[ -n $do_verbose ]] && echo $@
}


function error {
    echo "$prog: ERROR:" $@ >&2
}


function fatal {
    error $@
    exit 1
}


function warning {
    echo "$prog: WARNING:" $@ >&2
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

        V) echo "$prog $version"
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

    if [[ $file == .vimrc && ! -d ~/.vim//bundle/Vundle.vim ]]; then
        run_command git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
done

if [[ ! -d ~/.oh-my-zsh ]]; then
    run_command sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
    run_command git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [[ ! -d ~/.tmux/plugins ]]; then
    run_command git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
