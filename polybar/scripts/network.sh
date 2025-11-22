#!/usr/bin/env sh

if ! command -v nmcli > /dev/null; then 
    exit 1
fi

print_network_icon() {
    network_status="$(nmcli networking \
        | sed "s/\<enabled\>/true/; s/\<disabled\>/false/")"
    
    if $network_status ; then 
        active_device=$(nmcli -g DEVICE,TYPE,STATE,CONNECTION device \
            | grep -Ev ":(loopback|bridge|tun|unavailable|unmanaged|wifi-p2p):" \
            | grep -m 1 ":connected:")
        device_type="$(printf '%s\n' "$active_device" \
            | cut -d ':' -f 2)"

        case "$device_type" in
            ethernet) printf '%s\n' "󰈀" ;;
            wifi)     printf '%s\n' "" ;;
            *)        printf '%s\n' "󰌙" ;;
        esac 
    else 
        printf '%s\n' "󰌙"
    fi 
}

main() {
    operation=$1

    case $operation in
        status) print_network_icon   ;;
        menu) rofi-network-ctrl main ;;
        *) exit 2 ;;
    esac
}

main "$@"

