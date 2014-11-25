#!/bin/ksh

# set text-mode theme


prog=${0##*/}
version=1.0                        # program version (RCS revision if unset)


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
    Usage:  $prog  [options]  <theme>

$prog sets current theme for text-mode programs

$prog supports the following options:

    -v                        - verbose operation
    -d                        - debug mode
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

unset do_debug do_verbose

while getopts ":dhVv" opt ; do
    case $opt in
        d) do_debug=1
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

dtag="`date +%Y%m%d-%H%M%S`"


if [[ $# -ne 1 ]]; then
    usage
    exit 1
fi

typeset -l theme
theme=$1

# switch default gnome terminal theme

profile=$(gconftool-2  --recursive-list  "/apps/gnome-terminal/profiles" | \
    awk '$1 ~ /^\// {sub(/.*\//, "", $1); sub(/:$/, "", $1); profile = $1; } 
         $1 == "visible_name" && tolower($3) == theme {print profile}' theme=$theme)

if [[ -z $profile ]]; then
    error "No gnome terminal profile for theme $theme"
    exit 1
fi

default_profile=$(gconftool-2 --get "/apps/gnome-terminal/global/default_profile")

if [[ $profile != $default_profile ]]; then
    gconftool-2 --set "/apps/gnome-terminal/global/default_profile" --type string $profile
fi

rm ~/.theme-*
touch ~/.theme-$theme
exit 0

