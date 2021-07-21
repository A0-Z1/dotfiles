#!/bin/sh

# check if protonvpn is active
vpn=$( iwconfig proton0 |& awk '{print $2,$3,$4}' )
if [[ "$vpn" =~ "No such device" ]]; then
    icon=" "
else
    icon=" "
fi

wifi_status="% $icon$( iwgetid -r ) "
wifi_quality=$( iwconfig wlan0 | awk '/Link/ {print $2}' | tr -d a-zA-Z=)
wifi_quality=${wifi_quality::2}
(( wifi_quality=wifi_quality*100/70 ))
if [ $wifi_quality -eq 100 ]
then
    wifi_quality="$wifi_quality"
elif [ $wifi_quality -lt 10 ]
then
    wifi_quality="  $wifi_quality"
else
    wifi_quality=" $wifi_quality"
fi

echo "$wifi_quality$wifi_status"
