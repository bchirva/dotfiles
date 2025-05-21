#!/bin/bash

OPERATION=$1

case $OPERATION in 
    "status")
        if bluetooth-ctrl status | jq -e ".powered" > /dev/null; then
            if (( $(jq "[.[] | select(.connected == true)] | length" <<< "$(bluetooth-ctrl device list)") > 0 )); then 
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
