#!/usr/bin/env sh

main() {
    operation=$1

    case $operation in
        status) 
            if [ "$(network-ctrl system status)" = "true" ]; then 
                connection_type=$(network-ctrl device list \
                    | jq ".[] | select(.device == $(network-ctrl connection list \
                    | jq ".[0].device")).type" \
                    | sed -e "s/\"//g")

                case ${connection_type} in
                    ethernet) printf '%s\n' "󰈀"; exit ;;
                    wifi) printf '%s\n' ""; exit ;;
                    *) printf '%s\n' "󰌙"; exit ;;
                esac 
            fi 
            printf '%s\n' "󰌙"
        ;;
        menu) rofi-network-ctrl main ;;
        *) exit 2 ;;
    esac
}

main "$@"

