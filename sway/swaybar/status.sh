#!/bin/sh

# send header
echo '{"version": 1, "click_events":true}'

# begin the endless array
echo '['
echo '[]'

# now send block with status information forever; launched in a background
# asynchronous process
(while :
do
    echo -n ",["

    # show focused window name
    window_json="$( /home/a0z1/.config/sway/swaybar/window_title.sh )"
    echo -n "${window_json}"

    # show mail notifications
    mails="$( cat /home/a0z1/.config/sway/swaybar/mail_notifications )   "
    echo -n "{\"name\":\"email\",\"full_text\":\"$mails\", \"color\":\"#c0c0c0\"},"

    # show if xwayland is active or not
#    ds_icon=$( /home/a0z1/.config/sway/swaybar/ds_icon.sh )
#    echo -n "{\"full_text\":\" $ds_icon \", \"color\":\"#c0c0c0\"},"

    # cpu usage
    cpu=" $( mpstat | awk 'NR == 4 { printf ("%.2f", 100 - $12)}' )%  "
    echo -n "{\"name\":\"cpu\",\"full_text\":\"$cpu\", \"color\":\"#ffaf87\"},"

    # show memory status
    memory_status=" $( free | awk 'NR == 2 {printf ("%.2f", $3/$2*100)}' )%  "
    echo -n "{\"name\":\"mem\",\"full_text\":\"$memory_status\", \"color\":\"#d7d787\"},"

    # free disk space
    disk=" $( df -h | awk '/nvme0n1p3/ {print $4}' )  "
    echo -n "{\"name\":\"disk\",\"full_text\":\"$disk\", \"color\":\"#d7afff\"},"

    # wifi
    wifi="$( /home/a0z1/.config/sway/swaybar/wifi.sh )"
    echo -n "{\"name\":\"wifi\",\"full_text\":\"$wifi\", \"color\":\"#af87af\"},"

    # show audio status
    audio_status=" $( /home/a0z1/.config/sway/swaybar/audio.sh ) "
    echo -n "{\"name\":\"audio\",\"full_text\":\"$audio_status\", \"color\":\"#d7d7ff\"},"

    # show battery status
    b_status=$( acpi | awk -f '/home/a0z1/.config/sway/swaybar/battery.awk' )
    b_percentage=$( echo $b_status | cut -f 1 -d "," )
    b_color=$( echo $b_status | cut -f 2 -d "," )
    echo -n "{\"name\":\"batt\",\"full_text\":\" $b_percentage \", \"color\":\"$b_color\"},"

    # date
    dateformat=" $( date +"%a %Y-%m-%d %H:%M:%S" )"
    echo -n "{\"name\":\"clock\",\"full_text\":\"$dateformat \",\"separator\":1, \"color\":\"#5fd7d7\"},"

    # turn off or restart
#    echo -n "{\"name\":\"turn_off\",\"full_text\":\"  \",\"separator\":0}"

    echo -n "]"
    sleep 1
done) &

# Listening for STDIN events
while read line
do
    # DATE click
    if [[ $line == *"name"*"clock"* ]]; then
        notify-send --urgency=low --expire-time=20000 "$( cal )"

    # pavucontrol
    elif [[ $line == *"name"*"audio"* ]]; then
        pavucontrol &

    # wifi
    elif [[ $line == *"name"*"wifi"* ]]; then
        nm-connection-editor &

    # emails
    elif [[ $line == *"name"*"email"* ]]; then
        notify-send --urgency=low --icon=/home/a0z1/Pictures/Logos/mutt.png "$( new_mails )"

    # disk
    elif [[ $line == *"name"*"disk"* ]]; then
        foot --app-id terminal htop &

    # memory
    elif [[ $line == *"name"*"mem"* ]]; then
        notify-send --urgency=low "Memory hogs: $( ps -e -o comm,%mem --sort=-%mem | head -n10 )"

    # cpu
    elif [[ $line == *"name"*"cpu"* ]]; then
        notify-send --urgency=low "CPU hogs: $( ps -e -o comm,%cpu --sort=-%cpu | head -n10 )"

    # battery
    elif [[ $line == *"name"*"batt"* ]]; then
        notify-send --urgency=low "$( { sensors | tail -n5 | head -n4; acpi | awk 'BEGIN{print } {print $5,$6}'; } )"

    # turn off
#    elif [[ $line == *"name"*"turn_off"* ]]; then
#        swaynagmode -m "What would you like to do?" -b "shutdown" "shutdown now" -b "restart" "shutdown -r now"

    fi
done
