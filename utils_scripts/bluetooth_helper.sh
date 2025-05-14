#!/bin/bash 

source "$(dirname "${BASH_SOURCE[0]}")/common_utils.sh"

function toggle_power() {
    MODE=$1
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
    MODE=$1
    case $MODE in 
        "on") bluetoothctl --timeout 5 scan on >> /dev/null ;;
        "off") bluetoothctl scan off ;;
        *) exit ;;
    esac 
}

toggle_discoverable() {
    MODE=$1
    case $MODE in
        "on") bluetoothctl discoverable on ;;
        "off") bluetoothctl discoverable off ;;
        *) exit ;;
    esac 
}

toggle_pairable() {
    MODE=$1
    case $MODE in 
        "on") bluetoothctl pairable on ;;
        "off") bluetoothctl pairable off ;;
        *) exit ;;
    esac 
}

function bluetooth_status() {
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

function device_info() {
    DEVICE_ID=$1

    DEVICE_INFO=$(bluetoothctl info "${DEVICE_ID}")

    NAME=$(grep "Name:" <<< "${DEVICE_INFO}" | awk '{start=index($0, $2); print substr($0, start)}')
    CLASS=$(grep "Class:" <<< "${DEVICE_INFO}" | awk '{print $2}' | flag_to_bool)
    ICON=$(grep "Icon:" <<< "${DEVICE_INFO}" | awk '{print $2}' | flag_to_bool)
    PAIRED=$(grep "Paired:" <<< "${DEVICE_INFO}" | awk '{print $2}' | flag_to_bool)
    BONDED=$(grep "Bonded:" <<< "${DEVICE_INFO}" | awk '{print $2}' | flag_to_bool)
    TRUSTED=$(grep "Trusted:" <<< "${DEVICE_INFO}" | awk '{print $2}' | flag_to_bool)
    BLOCKED=$(grep "Blocked:" <<< "${DEVICE_INFO}" | awk '{print $2}' | flag_to_bool)
    CONNECTED=$(grep "Connected:" <<< "${DEVICE_INFO}" | awk '{print $2}' | flag_to_bool)

    jq -n "{ \
        id: \"${DEVICE_ID}\", \
        name: \"${NAME}\", \
        class: \"${CLASS}\", \
        icon: \"${ICON}\", \
        paired: ${PAIRED}, \
        bonded: ${BONDED}, \
        trusted: ${TRUSTED}, \
        blocked: ${BLOCKED}, \
        connected: ${CONNECTED} }"  
}

function devices_list() {
    DEVICES=$(bluetoothctl devices)
    RESULT="[]"

    while read -r line
    do
        DEVICE_ID=$(awk '{print $2}' <<< "$line")
        DEVICE_INFO=$(device_info "${DEVICE_ID}")
        RESULT=$(jq ". += [$(device_info "${DEVICE_ID}")]" <<< "$RESULT")
    done <<< "$DEVICES"

    echo "${RESULT}"
}

function connect_device() {
    DEVICE_ID=$1
    DEVICE_INFO=$(device_info "${DEVICE_ID}")

    if jq -e ".trusted | not" <<< "${DEVICE_INFO}" > /dev/null; then 
        bluetoothctl trust "${DEVICE_ID}"
    fi 

    if jq -e ".paired | not" <<< "${DEVICE_INFO}" > /dev/null; then 
        bluetoothctl pair "${DEVICE_ID}"
    fi 

    bluetoothctl connect "${DEVICE_ID}" 
}

function disconnect_device() {
    DEVICE_ID=$1
    bluetoothctl disconnect "${DEVICE_ID}"
}

function remove_device() {
    DEVICE_ID=$1
    bluetoothctl remove "${DEVICE_ID}"
}
