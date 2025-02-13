#!/bin/bash

WIRELESS_INTERFACES=($(nmcli device | awk '$2=="wifi" {print $1}'))
WIRELESS_INTERFACES_PRODUCT=()
WLAN_INT=0
WIRED_INTERFACES=($(nmcli device | awk '$2=="ethernet" {print $1}'))

function device_list_json {
    DEVICES=$(nmcli device | grep -E "ethernet|wifi" | grep -v "unavailable")
    RESULT="[]"
    while read line; do
        DEVICE_NAME=$(awk '{print $1}' <<< $line)
        DEVICE_TYPE=$(awk '{print $2}' <<< $line)
        DEVICE_STATUS=$(awk '{print $3}' <<< $line | sed "s/connected/true/g" | sed "s/disconnected/false/g")

        RESULT=$(jq ". += [{ \
            device: \"$DEVICE_NAME\", \
            type: \"$DEVICE_TYPE\", \
            status: $DEVICE_STATUS}]" \
            <<< $RESULT)
    done <<< "$DEVICES"
    echo "$RESULT"
}

function wifi_list_json { 
    WIFI_NETWORKS=$(nmcli --fields ssid device wifi list | sed '1d' | sed '/^--/d')
    RESULT="[]"
    while read line; do
        SSID=""
        SECURITY=""
        LEVEL=0
        STATUS=false

        RESULT=$(jq ". += [{ \
            ssid: \"$SSID\", \
            security: \"$SECURITY\", \
            level: $LEVEL, \
            status: $STATUS \
        }]" <<< $RESULT)
    done <<< $WIFI_NETWORKS

    echo "[]"
}

function vpn_list_json {
    VPN_NETWORKS=$()
    RESULT="[]"
    while read line; do
        NAME=""
        TYPE=""
        STATUS=false

        RESULT=$(jq ". += [{ \
            name: \"$SSID\", \
            type: \"$TYPE\", \
            status: $STATUS \
        }]" <<< $RESULT)
    done <<< $VPN_NETWORKS

    echo "[]"
}

function network_status {
    NETWORK_STATUS=$(nmcli networking | sed "s/enabled/true/g" | sed "s/disabled/false/g")

    RESULT=$(jq ". += { \
        total_status: $NETWORK_STATUS, \
        devices: $(device_list_json), \
        wifi: $(wifi_list_json), \
        vpn: $(vpn_list_json) }" \
        <<< "{}")

    echo "$RESULT"
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

