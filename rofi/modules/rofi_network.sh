#!/bin/bash 

source $HOME/.config/rofi/modules/rofi_icon.sh
source $HOME/.config/rofi/modules/utils_scripts/network_manager_helper.sh

function main_menu {
    ROFI_INPUT=""
    ROFI_MESSAGE=""

    TOTAL_STATUS=$(network_status)
    if $TOTAL_STATUS; then 
        ROFI_INPUT="$(pango_icon 󰖟 ) Network: <b>On</b>\n"

        DEVICES_JSON=$(device_list_json)
        DEVICES_COUNT=$(jq ". | length" <<< "$DEVICES_JSON")
        ACTIVE_CONNECTIONS=$(active_connections)
        
        if [[ "$ACTIVE_CONNECTIONS" ]]; then
            ACTIVE_DEVICE=$(jq ".[0].device" <<< "$ACTIVE_CONNECTIONS" | sed "s/\"//g")
            ACTIVE_CONNECTION=$(jq ".[0].connection" <<< "$ACTIVE_CONNECTIONS" | sed "s/\"//g")
            ROFI_MESSAGE="Connected to <b>$ACTIVE_CONNECTION</b> on <b>$ACTIVE_DEVICE</b>"
        fi 

        for DEVICE_IDX in $(seq 0 $((DEVICES_COUNT - 1)))
        do
            DEVICE_NAME=$(jq ".[$DEVICE_IDX].device" <<< "$DEVICES_JSON" | sed "s/\"//g")
            DEVICE_STATUS=$(jq ".[$DEVICE_IDX].status" <<< "$DEVICES_JSON" | sed "s/true/On/g" | sed "s/false/Off/g")
            
            case $(jq ".[$DEVICE_IDX].type" <<< "$DEVICES_JSON" | sed "s/\"//g") in
                "ethernet") if jq -e ".[$DEVICE_IDX].status" <<< "$DEVICES_JSON" > /dev/null; then DEVICE_ICON="󰈁"; else DEVICE_ICON="󰈂"; fi ;;
                "wifi")     if jq -e ".[$DEVICE_IDX].status" <<< "$DEVICES_JSON" > /dev/null; then DEVICE_ICON="󰖩"; else DEVICE_ICON="󰖪"; fi ;;
                *) exit ;;
            esac 

            CONNECTION=$(jq ".[] | select (.device == \"${DEVICE_NAME}\") .connection" <<< "$ACTIVE_CONNECTIONS" | sed "s/\"//g")
            if [[ "$CONNECTION" ]]; then 
                CONNECTION="($CONNECTION)"
            fi

            ROFI_INPUT="${ROFI_INPUT}$(pango_icon ${DEVICE_ICON}) ${DEVICE_NAME}: <b>${DEVICE_STATUS}</b> <i>$CONNECTION</i>\n"
        done

        WIFI_AVAILABLE=$(( $(jq '[ .[] | select(.type == "wifi") ] | length' <<< "$DEVICES_JSON") > 0 ? 1 : 0 ))
        if [ $WIFI_AVAILABLE -ne 0 ]; then 
            ROFI_INPUT="${ROFI_INPUT}$(pango_icon 󱛆 ) WiFi networks menu\n"
        fi

        VPNS_JSON=$(vpn_list_json)
        VPNS_COUNT=$(jq ". | length" <<< "$VPNS_JSON")
        for VPN_IDX in $(seq 0 $((VPNS_COUNT - 1)))
        do
            VPN_NAME=$(jq ".[$VPN_IDX].name" <<< "$DEVICES_JSON" | sed "s/\"//g")
            VPN_STATUS=$(jq ".[$VPN_IDX].status" <<< "$DEVICES_JSON" | sed "s/true/On/g" | sed "s/false/Off/g")
            ROFI_INPUT="${ROFI_INPUT}$(pango_icon 󰖂 )${VPN_NAME} <b>${VPN_STATUS}</b>\n"
        done

        ROFI_INPUT="${ROFI_INPUT}$(pango_icon 󰑓 ) Restart NetworkManager service\n"

    else
        ROFI_INPUT="$(pango_icon 󰪎 ) Network: <b>Off</b>\n"
        ROFI_MESSAGE="Network disabled"
    fi

    if [[ -z "$ROFI_MESSAGE" ]]; then 
        ROFI_MESSAGE="No connection"; 
    fi

    variant=$(echo -en "$ROFI_INPUT" | rofi -markup-rows -config "$HOME/.config/rofi/modules/controls_config.rasi"\
        -markup-rows -i -dmenu -p "Network:" -no-custom -format 'i' -mesg "$ROFI_MESSAGE" -l $((2 + DEVICES_COUNT + VPNS_COUNT + WIFI_AVAILABLE)) )

    if [ ! $variant ]; then
        exit;
    fi
    if (( variant == 0)); then 
        COMMAND=$(echo "$TOTAL_STATUS" | sed -e "s/true/off/g" -e "s/false/on/g")
        toggle_network $COMMAND
        if [[ "$COMMAND" == "on" ]]; then
            sleep 3
            main_menu 
        fi
    elif (( variant <= DEVICES_COUNT )); then
        toggle_device \
            $(jq ".[$(( variant - 1 ))].device" <<< "$DEVICES_JSON" | sed "s/\"//g") \
            $(jq ".[$(( variant - 1 ))].status" <<< "$DEVICES_JSON" | sed "s/true/off/g" | sed "s/false/on/g")
    elif (( variant == $((DEVICES_COUNT + 1)) )); then
        wifi_menu
    elif (( variant == $((DEVICES_COUNT + 2)) )); then
        pkexec systemctl restart NetworkManager
    else
        exit
    fi
}

function wifi_menu {
    ROFI_INPUT=""
    ROFI_MESSAGE=""

    WIFI_LIST_JSON=$(wifi_list_json)
    WIFI_COUNT=$(jq ". | length" <<< "$WIFI_LIST_JSON")

    ACTIVE_CONNECTIONS=$(active_connections)

    for WIFI_IDX in $(seq 0 $((WIFI_COUNT - 1)) )
    do
        WIFI_SSID=$(jq ".[$WIFI_IDX].ssid" <<< "${WIFI_LIST_JSON}" | sed "s/\"//g")
        WIFI_SECURITY=$(jq ".[$WIFI_IDX].security" <<< "${WIFI_LIST_JSON}" | sed "s/\"//g")
        WIFI_SIGNAL=$(jq ".[$WIFI_IDX].signal" <<< "${WIFI_LIST_JSON}")

        if   (( WIFI_SIGNAL <= 12 )); then 
            if jq -e ".[$WIFI_IDX].known" <<< "${WIFI_LIST_JSON}" > /dev/null; then WIFI_SIGNAL_ICON="󰤯"; else WIFI_SIGNAL_ICON="󰤬"; fi
        elif (( WIFI_SIGNAL <= 37 )); then 
            if jq -e ".[$WIFI_IDX].known" <<< "${WIFI_LIST_JSON}" > /dev/null; then WIFI_SIGNAL_ICON="󰤟"; else WIFI_SIGNAL_ICON="󰤡"; fi
        elif (( WIFI_SIGNAL <= 62 )); then 
            if jq -e ".[$WIFI_IDX].known" <<< "${WIFI_LIST_JSON}" > /dev/null; then WIFI_SIGNAL_ICON="󰤢"; else WIFI_SIGNAL_ICON="󰤤"; fi
        elif (( WIFI_SIGNAL <= 87 )); then 
            if jq -e ".[$WIFI_IDX].known" <<< "${WIFI_LIST_JSON}" > /dev/null; then WIFI_SIGNAL_ICON="󰤥"; else WIFI_SIGNAL_ICON="󰤧"; fi
        elif (( WIFI_SIGNAL <= 100 )); then 
            if jq -e ".[$WIFI_IDX].known" <<< "${WIFI_LIST_JSON}" > /dev/null; then WIFI_SIGNAL_ICON="󰤨"; else WIFI_SIGNAL_ICON="󰤪"; fi
        fi

        CONNECTION=$(jq ".[] | select (.connection == \"${WIFI_SSID}\") .device" <<< "$ACTIVE_CONNECTIONS" | sed "s/\"//g")
        if [[ "$CONNECTION" ]]; then 
            ROFI_MESSAGE="Connected to <b>$WIFI_SSID</b> on <b>$CONNECTION</b>"
            CONNECTION="[$CONNECTION]"
        fi 

        ROFI_INPUT="${ROFI_INPUT}$(pango_icon "${WIFI_SIGNAL_ICON}") ${WIFI_SSID} <i>(${WIFI_SECURITY})</i> <b>$CONNECTION</b>\n"
    done

    ROFI_INPUT="${ROFI_INPUT}$(pango_icon 󰑓 ) Rescan WiFi networks\n"

    if [[ -z "$ROFI_MESSAGE" ]]; then ROFI_MESSAGE="No connection"; fi

    variant=$(echo -en "$ROFI_INPUT" | rofi -markup-rows -config "$HOME/.config/rofi/modules/controls_config.rasi"\
        -i -dmenu -p "WiFi:" -no-custom -format 'i' -mesg "$ROFI_MESSAGE" -l $((WIFI_COUNT + 1)) )

    if [ ! $variant ]; then exit; fi
    if (( variant == WIFI_COUNT)); then 
        nmcli device wifi rescan
        @0
    elif (( variant <= WIFI_COUNT )); then
        SELECTED_SSID=$(jq ".[$variant].ssid" <<< "${WIFI_LIST_JSON}" | sed "s/\"//g")
        if [[ "$(jq ".[] | select (.connection == \"${SELECTED_SSID}\") .device" <<< "${ACTIVE_CONNECTIONS}")" ]]; then
            disconnect_from_wifi "${SELECTED_SSID}"
        elif eval $(jq ".[$variant].known" <<< "${WIFI_LIST_JSON}"); then 
            connect_to_wifi "${SELECTED_SSID}"
        else 
            SSID_PASSWORD=$(rofi -config "$HOME/.config/rofi/modules/input_config.rasi" -dmenu -p "Password:" -password)
            connect_to_wifi "${SELECTED_SSID}" "${SSID_PASSWORD}"
        fi 
    fi
}

case $1 in
    "main") main_menu ;;
    "wifi") wifi_menu ;;
    *) exit ;;
esac
