#!/bin/bash

source ~/.config/polybar/scripts/utils_scripts/network_manager_helper.sh

operation=$1

case $operation in
    "status") 
        if [[ "$(network_status)" == "true" ]]; then 
            CONNECTION_TYPE=$(device_list_json | jq ".[] | select(.device == $(active_connections | jq ".[0].device")).type" | sed -e "s/\"//g")

            case ${CONNECTION_TYPE} in
                "ethernet") echo "󰈀"; exit ;;
                "wifi") echo ""; exit ;;
                *) echo "󰌙"; exit ;;
            esac 
        fi 
        echo "󰌙"
    ;;
    "menu") ~/.config/rofi/modules/rofi_network.sh main;;
esac
