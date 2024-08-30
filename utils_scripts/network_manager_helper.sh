#!/bin/bash

function network_status {
    NETWORK_STATUS=$(nmcli networking)

    ACTIVE_NETWORK=$(nmcli --fields state,type,connection device | sed '1d'\
        | grep "wifi" | grep -w "connected" | awk {'print $3'})
    
}

function wifi_network_list {
    readarray -t WIFI_NETWORKS <<< $(nmcli --fields ssid device wifi list | sed '1d' | sed '/^--/d')
    JSON_ARRAY="[]"
    for i in ${!WIFI_NETWORKS[*]}
    do
        JSON_ARRAY=$(jq  ". += [${WIFI_NETWORKS[$i]}]" <<< $JSON_ARRAY)
    done

    echo $JSON_ARRAY
}

function toggle_network {
    MODE=$1 # on/off 
    nmcli networking $MODE
}

function toggle_device {
    ADAPTER=$1
    DEVICE=$2 # on/off

    case $MODE in
        "on")  nmcli device connect $DEVICE ;;
        "off") nmcli device disconnect $DEVICE ;;
        *) exit ;;
    esac
}

function toggle_wifi {
    MODE=$1 # on/off
    nmcli radio wifi $MODE
}

function connect_to_wifi {
    while getopts n:p PARAMS
    do
        case "${PARAMS}" in
            n) NETWORK_SSID=${OPTARG} ;;
            p) NETWORK_PASSWORD=${OPTARG} ;;
        esac
    done

    if [ -z "$NETWORK_PASSWORD"] 
    then
        nmcli connection down $NETWORK_SSID
    else
        nmcli device wifi connect $NETWORK_SSID password $NETWORK_PASSWORD
    fi
}

function disconnect_from_wifi {
    NETWORK_SSID=$1
    nmcli connection down $NETWORK_SSID
}

