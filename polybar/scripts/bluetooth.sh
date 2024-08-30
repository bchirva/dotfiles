#!/bin/bash

operation=$1

case $operation in 
    "status")
        bluetooth_status=$(bluetoothctl show | grep -e "Powered" | awk '{print $2}')
        case $bluetooth_status in 
            "yes") echo "" ;;
            "no" ) echo "󰂲" ;;
        esac
    ;;
    "menu") ~/.config/rofi/modules/rofi_bluetooth.sh ;;
    *) exit ;;
esac
