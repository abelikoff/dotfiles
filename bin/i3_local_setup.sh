#!/bin/bash

readonly ws_dir=$HOME/.i3-workspace

if [ ! -d $ws_dir ]; then
    exit 0
fi

for x in 1 2 3 4; do
    if [ -f $ws_dir/$x.json ]; then
        i3-msg "workspace $x; append_layout $ws_dir/$x.json"
        sleep 1
    fi
done

$ws_dir/start.sh
