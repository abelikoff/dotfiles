#!/bin/ksh

# set up configuration files


CONF_FILES=".bash_aliases
            .bashrc
            .emacs
            .profile
            .pylintrc
            .screenrc
            .vim
            .vimrc
            .wgetrc"

prog=${0##*/}
version=1.0


# figure out scratch directory

if [[ -z $TMPDIR ]]; then
    if [[ -d /usr/tmp ]]; then
	export TMPDIR=/usr/tmp
    else
	export TMPDIR=/tmp
    fi
fi


function usage {
    print "
    Usage:  $prog  [options]

$prog sets up configuration files


$prog supports the following options:

    -f                        - perform changes (default: dry run)

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

unset do_verbose
dry_run=1

while getopts ":fhVv" opt ; do
    case $opt in
	f) unset dry_run
	   ;;
      
	h) usage
	   exit 0 
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

if [[ -n $dry_run ]]; then
  pfx="echo WILL RUN: "
else
  unset pfx
fi

DF_DIR=$(dirname $0)

if [[ $DF_DIR == "." ]]; then
    DF_DIR=$(pwd)
fi

cd ~ || exit 1
DF_DIR=${DF_DIR##$(pwd)/}       # change to relative path
BACKUP_DIR=~/CONFIG_BACKUP.$(date +"%Y%m%d-%H%M%S")

for file in $CONF_FILES; do
    tgt=$DF_DIR/$file

    if [[ -L $file ]]; then
	old_tgt="$(readlink $file)"

	if [[ $tgt == $old_tgt ]]; then
	    verbose "NOTICE: $file is already set up correctly - skipping."
	    continue
	fi
    fi
    
    if [[ -e $file ]]; then
	if diff -w $file $tgt > /dev/null; then
	    print -u2 "NOTICE: $file is same as target - not backing up"
            $pfx rm -f $file
	else
            $pfx mkdir -p $BACKUP_DIR
            print -u2 "NOTICE: $file will be saved to $BACKUP_DIR"
	    $pfx mv $file $BACKUP_DIR/
	fi
    fi

    verbose "$file -> $tgt"
    $pfx ln -s $tgt .
done
