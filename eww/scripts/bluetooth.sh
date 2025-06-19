#!/usr/bin/env bash

function main() {
    local -r operation=$1

    case $operation in 
        "status")
            if bluetooth-ctrl status \
                | jq -e ".powered" > /dev/null; then 

                local -r connected_devices=$(jq "[.[] | select(.connected == true)] | length" <<< "$(bluetooth-ctrl device list)")
                jq -n "{ \
                    enabled: true, \
                    connected: ${connected_devices} }"
            else 
                jq -n "{ enabled: false }"
            fi 
        ;;
        "toggle")
            local -r toggle_flag=$(bluetooth-ctrl status \
                | jq ".powered" \
                | sed -e "s/true/off/g" -e "s/false/on/g")

            bluetooth-ctrl power "${toggle_flag}"
        ;;
        "menu") rofi-bluetooth-ctrl main ;;
        *) exit 2 ;;
    esac
}

main "$@"
