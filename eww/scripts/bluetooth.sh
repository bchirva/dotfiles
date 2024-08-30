#!/bin/bash

operation=$1

bluetooth_status=$(bluetoothctl show | grep -e "Powered" | awk '{print $2}')

case $operation in 
    "status")
        case $bluetooth_status in 
            "yes") echo "{\"enabled\": true}"  ;;
            "no" ) echo "{\"enabled\": false}" ;;
        esac
    ;;
    "toggle")
        case $bluetooth_status in 
            "yes") bluetoothctl power off ;;
            "no" ) bluetoothctl power on  ;;
        esac
    ;;
    "menu") ~/.config/rofi/modules/rofi_bluetooth.sh ;;
    *) exit ;;
esac
