#!/bin/bash 

source $HOME/.config/rofi/modules/utils_scripts/network_manager_helper.sh

function main_menu {
    ROFI_INPUT=""
    ROFI_MESSAGE=""

    TOTAL_STATUS=$(network_status)
    if $TOTAL_STATUS; then 
        ROFI_INPUT="Network: <b>On</b>\0icon\x1fnetwork-connect\n"

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
            DEVICE_ICON=$(jq ".[$DEVICE_IDX].type" <<< "$DEVICES_JSON" | sed "s/\"//g" \
                | sed "s/ethernet/network-wired/g" \
                | sed "s/wifi/network-wireless/g")

            if ! $(jq ".[$DEVICE_IDX].status" <<< "$DEVICES_JSON") ; then
                DEVICE_ICON="${DEVICE_ICON}-disconnected"
            fi
            
            CONNECTION=$(jq ".[] | select (.device == \"${DEVICE_NAME}\") .connection" <<< "$ACTIVE_CONNECTIONS" | sed "s/\"//g")
            if [[ "$CONNECTION" ]]; then 
                CONNECTION="($CONNECTION)"
            fi

            ROFI_INPUT="${ROFI_INPUT}${DEVICE_NAME}: <b>${DEVICE_STATUS}</b> <i>$CONNECTION</i>\0icon\x1f${DEVICE_ICON}\n"
        done

        WIFI_AVAILABLE=$(( $(jq '[ .[] | select(.type == "wifi") ] | length' <<< "$DEVICES_JSON") > 0 ? 1 : 0 ))
        if [ $WIFI_AVAILABLE -ne 0 ]; then 
            ROFI_INPUT="${ROFI_INPUT}WiFi networks menu\0icon\x1fnetwork-wireless-acquiring\n"
        fi

        VPNS_JSON=$(vpn_list_json)
        VPNS_COUNT=$(jq ". | length" <<< "$VPNS_JSON")
        for VPN_IDX in $(seq 0 $((VPNS_COUNT - 1)))
        do
            VPN_NAME=$(jq ".[$VPN_IDX].name" <<< "$DEVICES_JSON" | sed "s/\"//g")
            VPN_STATUS=$(jq ".[$VPN_IDX].status" <<< "$DEVICES_JSON" | sed "s/true/On/g" | sed "s/false/Off/g")

            ROFI_INPUT="${ROFI_INPUT}${VPN_NAME} <b>${VPN_STATUS}</b>\0icon\x1fnetwork-vpn\n"
        done

    else
        ROFI_INPUT="Network: <b>Off</b>\0icon\x1fnetwork-disconnect\n"
        ROFI_MESSAGE="Network disabled"
    fi

    if [[ -z "$ROFI_MESSAGE" ]]; then 
        ROFI_MESSAGE="No connection"; 
    fi

    variant=$(echo -en "$ROFI_INPUT" | rofi -markup-rows -config "$HOME/.config/rofi/modules/controls_config.rasi"\
        -i -dmenu -p "Network:" -no-custom -format 'i' -mesg "$ROFI_MESSAGE" -l $((1 + DEVICES_COUNT + VPNS_COUNT + WIFI_AVAILABLE)) )

    if [ ! $variant ]; then
        exit;
    fi
    if (( variant == 0)); then 
        COMMAND=$(echo "$TOTAL_STATUS" | sed "s/true/off/g" | sed "s/false/on/g")
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
        vpn_menu
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
        WIFI_SSID=$(jq ".[$WIFI_IDX].ssid" <<< "$WIFI_LIST_JSON" | sed "s/\"//g")
        WIFI_SECURITY=$(jq ".[$WIFI_IDX].security" <<< "$WIFI_LIST_JSON" | sed "s/\"//g")
        WIFI_SIGNAL=$(jq ".[$WIFI_IDX].signal" <<< "$WIFI_LIST_JSON")

        if eval $(jq ".[$WIFI_IDX].known" <<< "$WIFI_LIST_JSON"); then
            WIFI_SIGNAL_ICON="network-wireless"
        else 
            WIFI_SIGNAL_ICON="network-wireless-secure"
        fi

        if   (( WIFI_SIGNAL <= 12 )); then 
            WIFI_SIGNAL_ICON="${WIFI_SIGNAL_ICON}-signal-none"
        elif (( WIFI_SIGNAL <= 37 )); then 
            WIFI_SIGNAL_ICON="${WIFI_SIGNAL_ICON}-signal-low"
        elif (( WIFI_SIGNAL <= 62 )); then 
            WIFI_SIGNAL_ICON="${WIFI_SIGNAL_ICON}-signal-ok"
        elif (( WIFI_SIGNAL <= 87 )); then 
            WIFI_SIGNAL_ICON="${WIFI_SIGNAL_ICON}-signal-good"
        elif (( WIFI_SIGNAL <= 100 )); then 
            WIFI_SIGNAL_ICON="${WIFI_SIGNAL_ICON}-signal-excellent"
        fi

        CONNECTION=$(jq ".[] | select (.connection == \"${WIFI_SSID}\") .device" <<< "$ACTIVE_CONNECTIONS" | sed "s/\"//g")
        if [[ "$CONNECTION" ]]; then 
            ROFI_MESSAGE="Connected to <b>$WIFI_SSID</b> on <b>$CONNECTION</b>"
            CONNECTION="[$CONNECTION]"
        fi 

        ROFI_INPUT="${ROFI_INPUT}${WIFI_SSID} <i>(${WIFI_SECURITY})</i> <b>$CONNECTION</b>\0icon\x1f${WIFI_SIGNAL_ICON}\n"
    done

    ROFI_INPUT="${ROFI_INPUT}Rescan WiFi networks\0icon\x1fview-refresh\n"

    if [[ -z "$ROFI_MESSAGE" ]]; then ROFI_MESSAGE="No connection"; fi

    variant=$(echo -en "$ROFI_INPUT" | rofi -markup-rows -config "$HOME/.config/rofi/modules/controls_config.rasi"\
        -i -dmenu -p "WiFi:" -no-custom -format 'i' -mesg "$ROFI_MESSAGE" -l $((WIFI_COUNT + 1)) )

    if [ ! $variant ]; then exit; fi
    if (( variant == WIFI_COUNT)); then 
        nmcli device wifi rescan
        @0
    elif (( variant <= WIFI_COUNT )); then
        SELECTED_SSID=$(jq ".[$variant].ssid" <<< "$WIFI_LIST_JSON" | sed "s/\"//g")
        if [[ "$(jq ".[] | select (.connection == \"${SELECTED_SSID}\") .device" <<< "$ACTIVE_CONNECTIONS")" ]]; then
            disconnect_from_wifi "$SELECTED_SSID"
        elif eval $(jq ".[$variant].known" <<< "$WIFI_LIST_JSON"); then 
            connect_to_wifi "$SELECTED_SSID"
        else 
            SSID_PASSWORD=$(rofi -config "$HOME/.config/rofi/modules/input_config.rasi" -dmenu -p "Password:" -password)
            connect_to_wifi "$SELECTED_SSID" "$SSID_PASSWORD"
        fi 
    fi
}

case $1 in
    "main") main_menu ;;
    "wifi") wifi_menu ;;
    *) exit ;;
esac
