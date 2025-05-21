#!/bin/bash

OPERATION=$1

case $OPERATION in
    "status") 
        if [[ "$(network-ctrl system status)" == "true" ]]; then 
            CONNECTION_TYPE=$(network-ctrl device list | jq ".[] | select(.device == $(network-ctrl connections list | jq ".[0].device")).type" | sed -e "s/\"//g")

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
