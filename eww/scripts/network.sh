#!/bin/bash

source ~/.config/eww/scripts/utils_scripts/network_manager_helper.sh

operation=$1

case $operation in
    "status")
        overall=""
        if [[ $(nmcli networking) == "enabled" ]]; then
            overall="true"
        else
            overall="false"
        fi
        network=$(nmcli --fields state,type,connection device | sed '1d')
        dev_count=$(wc -l <<< $network)
        result="{\"enabled\": \"$overall\", \"connected\": false}"
        
        for ((i = 1; i <= $dev_count; i++))
        do
            net_device=$(sed -n "${i}p" <<< $network)
            if [[ $(awk '{print $1}' <<< $net_device) == "connected" ]]; then
                result="{\"enabled\": \"$overall\", \"connected\": true, \"type\": \"$(awk '{print $2}' <<< $net_device)\", \"name\": \"$(awk '{print $3}' <<< $net_device)\"}"
                break
            fi
        done
        echo $result
    ;;
    "menu") ~/.config/rofi/modules/rofi_network.sh ;;
    "toggle")
        current_status=$(nmcli networking)
        case $current_status in
            "enabled") nmcli networking off ;;
            "disabled") nmcli networking on ;;
        esac
        ;;
esac
