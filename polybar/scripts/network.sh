#!/bin/bash

source ~/.config/polybar/scripts/utils_scripts/network_manager_helper.sh

operation=$1

case $operation in
    "status")
        if [[ $(nmcli networking) == "enabled" ]]; then
            networks=()
            readarray -t networks <<< $(nmcli --fields state,type,connection device | sed '1d')
           
            for i in ${!networks[*]} 
            do
                if [[ $(awk '{print $1}' <<< ${networks[$i]}) == "connected" ]]; then
                    device_type=$(awk '{print $2}' <<< ${networks[$i]})

                    if [[ "$device_type" == "wifi" ]]; then
                        echo ""
                    elif [[ "$device_type" == "ethernet" ]]; then
                        echo "󰈀"
                    fi
                    break
                fi
            done
        else
            echo "󰌙"
        fi
    ;;
    "menu") ~/.config/rofi/modules/rofi_network.sh main;;
esac
