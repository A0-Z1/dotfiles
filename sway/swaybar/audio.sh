#!/bin/sh

audio_status=$( pactl list sinks | awk '/^\s+(Mute|Volume|Active Port)/ { \
if($1=="Mute:") \
print $2;
else if ($1=="Volume:") \
print $5; \
else
print $3}' )

# turn it into array
audio_status=($audio_status)

audio=${audio_status[1]}

if [ "${audio_status[0]}" = "no" ]; then
    if [ "${audio_status[2]}" = "analog-output-headphones" ]; then
        echo "$audio "
    else
        echo "$audio 墳"
    fi
else
    echo "$audio 婢"
fi
