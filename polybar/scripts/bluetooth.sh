#!/usr/bin/env bash

function main() {
    local -r operation=$1

    case $operation in 
        "status")
            if bluetooth-ctrl status \
                | jq -e ".powered" > /dev/null; then
                if (( $(jq "[.[] | select(.connected == true)] | length" <<< "$(bluetooth-ctrl device list)") > 0 )); then 
                    echo "󰂱"
                else 
                    echo "󰂯"
                fi 
            else 
                echo "󰂲"; 
            fi
        ;;
        "menu") rofi-bluetooth-ctrl main;;
        *) exit 2;;
    esac
}

main "$@"
