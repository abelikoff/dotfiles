#!/bin/ksh

# set up configuration files


URLS="http://www.emacswiki.org/emacs/download/column-marker.el
"

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

    -c                        - on Windows, install for Cygwin
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

unset do_verbose install_for_cygwin
dry_run=1

while getopts ":cfhVv" opt ; do
    case $opt in
        c) install_for_cygwin=1
	   ;;

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


# target directory

OS=$(uname)

if [[ $OS == "Linux" || $OS == "Darwin" ]]; then
    ELISP_DIR=$HOME/lib/elisp
elif [[ $(uname) == "CYGWIN*" ]]; then
    if [[ -n $install_for_cygwin ]]; then
        ELISP_DIR=$HOME/lib/elisp
    else
        ELISP_DIR="C:\\tools\\elisp"
    fi
else
    fatal "unknown OS: $OS"
fi

mkdir -p $ELISP_DIR && cd $ELISP_DIR || \
    fatal "cannot change to directory $ELISP_DIR"

for url in $URLS; do
    file=${url##*/}

    if [[ $file == *.tar.gz ]]; then
	error "ignoring TGZ for now"
    elif [[ ! -f $file ]]; then
	$pfx wget --quiet "$url" || \
	    error "failed to download $url"
    else
	print -u2 "NOTICE: $file is already present"
    fi
done
