#!/usr/bin/env bash

function main(){
    local -r operation=$1

    case $operation in
        "status") 
            if [[ "$(network-ctrl system status)" == "true" ]]; then 
                local -r connection_type=$(network-ctrl device list \
                    | jq ".[] | select(.device == $(network-ctrl connection list \
                    | jq ".[0].device")).type" \
                    | sed -e "s/\"//g")

                case ${connection_type} in
                    "ethernet") echo "󰈀"; exit ;;
                    "wifi") echo ""; exit ;;
                    *) echo "󰌙"; exit ;;
                esac 
            fi 
            echo "󰌙"
        ;;
        "menu") rofi-network-ctrl main ;;
        *) exit 2 ;;
    esac
}

main "$@"

