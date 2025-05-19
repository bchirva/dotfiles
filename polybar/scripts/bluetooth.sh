#!/bin/bash

source ~/.config/polybar/scripts/utils_scripts/bluetooth_helper.sh

operation=$1

case $operation in 
    "status")
        if bluetooth_status | jq -e ".powered" > /dev/null; then
            if (( $(jq "[.[] | select(.connected == true)] | length" <<< "$(devices_list)") > 0 )); then 
                echo "󰂱"
            else 
                echo "󰂯"
            fi 
        else 
            echo "󰂲"; 
        fi
    ;;
    "menu") ~/.config/rofi/modules/rofi_bluetooth.sh main;;
    *) exit ;;
esac
