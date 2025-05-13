#!/bin/bash 

source "$(dirname "${BASH_SOURCE[0]}")/common_utils.sh"

function toggle_power() {
    local MODE=$1
    case $MODE in
        "on") 
            if rfkill list bluetooth | grep -q "blocked: yes"; then 
                rfkill unblock bluetooth && sleep 3
            fi 
            bluetoothctl power on;;
        "off") bluetoothctl power off;;
        *) exit;;
    esac
}

function toggle_scan() {
    local MODE=$1
    case $MODE in 
        "on") bluetoothctl --timeout 5 scan on ;;
        "off") bluetoothctl scan off ;;
        *) exit ;;
    esac 
}

toggle_discoverable() {
    local MODE=$1
    case $MODE in
        "on") bluetoothctl discoverable on ;;
        "off") bluetoothctl discoverable off ;;
        *) exit ;;
    esac 
}

toggle_pairable() {
    local MODE=$1
    case $MODE in 
        "on") bluetoothctl pairable on ;;
        "off") bluetoothctl pairable off ;;
        *) exit ;;
    esac 
}

function bluetooth_status() {
    local STATUS
    local POWERED
    local SCANNING
    local PAIRABLE
    local DISCOVERABLE
 
    STATUS=$(bluetoothctl show)
    POWERED=$(grep "PowerState:" <<< "${STATUS}" | awk '{print $2}' | flag_to_bool )
    SCANNING=$(grep "Discovering:" <<< "${STATUS}" | awk '{print $2}' | flag_to_bool )
    PAIRABLE=$(grep "Pairable:" <<< "${STATUS}"| awk '{print $2}' | flag_to_bool )
    DISCOVERABLE=$(grep "Discoverable:" <<< "${STATUS}" | awk '{print $2}' | flag_to_bool )

    jq -n "{ \
        powered: ${POWERED}, \
        scanning: ${SCANNING}, \
        pairable: ${PAIRABLE}, \
        discoverable: ${DISCOVERABLE} }"
}

function devices_list() {
    echo "LIST"
}
