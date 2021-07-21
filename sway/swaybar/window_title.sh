#!/bin/sh

# get focused window title
title=$(swaymsg -t get_tree | \
    # get focused window info
    jq -r '..|try select(.focused == true)' | \
    # clean info
    grep name | tr -d '"\\,' | tr -d "'" | \
    # print
    awk '{$1=""; print $0}' )

# check if string too long, it it is shorten it
len_title=${#title}
[ "$len_title" -gt 70 ] && title=${title::70}

json="{\"color\":\"#ebdbb2\",\"full_text\":\"$title\",\"align\":\"center\",\"min_width\":950,\"separator\":0},"
[ -n "$title" ] && echo $json
