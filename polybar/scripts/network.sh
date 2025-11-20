#!/usr/bin/env sh

main() {
    operation=$1

    case $operation in
        status) 
            if "$(network-ctrl system status)" ; then 
                active_device=$(network-ctrl connection list \
                    | sed -n "1{s/\s.*$// ; p}")
                device_type=$(network-ctrl device list \
                    | sed -n "/^$active_device/{s/^[^\t]*\t// ; s/\t.*$// ; p}") 

                case $device_type in
                    ethernet) printf '%s\n' "󰈀"; exit ;;
                    wifi)     printf '%s\n' ""; exit ;;
                    *)        printf '%s\n' "󰌙"; exit ;;
                esac 
            fi 
            printf '%s\n' "󰌙"
        ;;
        menu) rofi-network-ctrl main ;;
        *) exit 2 ;;
    esac
}

main "$@"

