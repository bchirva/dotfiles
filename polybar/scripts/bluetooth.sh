#!/usr/bin/env sh

main() {
    operation=$1

    case $operation in 
        status)
            if bluetooth-ctrl status \
                | jq -e ".powered" > /dev/null; then
                if [ "$(bluetooth-ctrl device list \
                    | jq "[.[] | select(.connected == true)] | length" )" \
                    -gt 0 ]
                then 
                    printf '%s\n' "󰂱"
                else 
                    printf '%s\n' "󰂯"
                fi 
            else 
                printf '%s\n' "󰂲"; 
            fi
        ;;
        menu) rofi-bluetooth-ctrl main;;
        *) exit 2;;
    esac
}

main "$@"
