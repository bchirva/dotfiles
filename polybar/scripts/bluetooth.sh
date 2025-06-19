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
        "menu") ${XDG_CONFIG_HOME}/rofi/modules/rofi_bluetooth.sh main;;
        *) exit 2;;
    esac
}

main "$@"
