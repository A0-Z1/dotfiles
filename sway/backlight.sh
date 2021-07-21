#!/bin/sh

read light < /tmp/backlight

if [ "$light" -eq "0" ]; then
    swaymsg "output * dpms on"
    echo 1 > /tmp/backlight
else
    swaymsg "output * dpms off"
    echo 0 > /tmp/backlight
fi
