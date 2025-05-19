#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/common_utils.sh"

function active_connections {
    CONNECTIONS=$(nmcli -t -f device,name connection show --active --order active:name)
    RESULT="[]"
    while read -r line
    do 
        CONNECTION_DEVICE=$(awk -F ':' '{print $1}' <<< "$line")
        CONNECTION_NAME=$(awk -F ':' '{print $2}' <<< "$line")
        RESULT=$(jq ". += [{ \
            connection: \"$CONNECTION_NAME\", \
            device: \"$CONNECTION_DEVICE\"}]" \
            <<< "$RESULT")
    done <<< "$CONNECTIONS"
    echo "$RESULT"
}

function device_list_json {
    DEVICES=$(nmcli -t device status | grep --color=never -E "ethernet|wifi" | grep --color=never -Ev "unavailable|unmanaged|p2p")
    RESULT="[]"
    while read -r line
    do
        DEVICE_NAME=$(awk -F ':' '{print $1}' <<< "$line")
        DEVICE_TYPE=$(awk -F ':' '{print $2}' <<< "$line")
        DEVICE_STATUS=$(awk -F ':' '{print $3}' <<< "$line" | flag_to_bool)

        RESULT=$(jq ". += [{ \
            device: \"$DEVICE_NAME\", \
            type: \"$DEVICE_TYPE\", \
            status: $DEVICE_STATUS}]" \
            <<< "$RESULT")
    done <<< "$DEVICES"
    echo "$RESULT"
}

function wifi_list_json { 
    WIFI_NETWORKS=$(nmcli -t -f ssid,signal,security device wifi list | grep -Ev "^:")
    KNOWN_WIFI_NETWORKS=$(nmcli -t -f name,type,device connection | grep -E "wireless" | awk -F ':' '{print $1}' \
        | jq --raw-input --null-input "[inputs]")
 
    RESULT="[]"
    while read -r line
    do
        SSID=$(awk -F ':' '{print $1}' <<< "$line")
        SIGNAL=$(awk -F ':' '{print $2}' <<< "$line")
        SECURITY=$(awk -F ':' '{print $3}' <<< "$line")

        if [[ $(jq ".[] | select(. == \"${SSID}\")" <<< "$KNOWN_WIFI_NETWORKS") ]]; then 
            KNOWN=true 
        else 
            KNOWN=false 
        fi
        
        RESULT=$(jq ". += [{ \
            ssid: \"$SSID\", \
            security: \"$SECURITY\", \
            signal: $SIGNAL, \
            known: $KNOWN \
        }]" <<< "$RESULT")
    done <<< "$WIFI_NETWORKS"

    echo "$RESULT"
}

function vpn_list_json {
    # VPN_NETWORKS=$()
    # RESULT="[]"
    # while read -r line; do
    #     NAME=""
    #     TYPE=""
    #     STATUS=false
    #
    #     RESULT=$(jq ". += [{ \
    #         name: \"$SSID\", \
    #         type: \"$TYPE\", \
    #         status: $STATUS \
    #     }]" <<< "$RESULT")
    # done <<< "$VPN_NETWORKS"
    #
    echo "[]"
}

function network_status {
    nmcli networking | flag_to_bool 
}

function toggle_network {
    MODE=$1 # on/off 
    nmcli networking $MODE
}

function toggle_device {
    DEVICE=$1
    MODE=$2 # on/off

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
    NETWORK_SSID="$1"
    NETWORK_PASSWORD="$2"

    if [ -z "$NETWORK_PASSWORD" ] 
    then
        nmcli connection up "$NETWORK_SSID"
    else
        nmcli device wifi connect "$NETWORK_SSID" password "$NETWORK_PASSWORD"
    fi
}

function disconnect_from_wifi {
    NETWORK_SSID=$1
    nmcli connection down "$NETWORK_SSID"
}

