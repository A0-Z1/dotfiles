#!/bin/sh

active=$( ps aux | grep -i xwayland | wc -l )
if [ "$active" -gt 1 ]; then
    echo X11
else
    echo wayland
fi
