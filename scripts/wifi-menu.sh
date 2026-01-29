#usr/bin/env bash

iwd_not_running=$(systemctl status iwd | grep -i "inactive")
if [[ ! -z "$iwd_not_running" ]]; then
    notify-send "iwd service is not running"
else
    wifi_devices=$(iwctl device list | grep -i "wlan")
    if [[ -z "$wifi_devices" ]]; then
        notify-send "No wifi devices found"
    else
        impala
    fi
fi
