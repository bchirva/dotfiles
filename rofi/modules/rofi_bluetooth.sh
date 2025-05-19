#!/bin/bash

source $HOME/.config/rofi/modules/rofi_icon.sh
source $HOME/.config/rofi/modules/utils_scripts/bluetooth_helper.sh

function main_menu {
    TOTAL_STATUS=$(bluetooth_status)

    ROFI_INPUT=""
    if jq -e ".powered" <<< "${TOTAL_STATUS}" > /dev/null; then 
        ROFI_INPUT="${ROFI_INPUT}$(pango_icon ) Power: <b>On</b>\n"
    else 
        ROFI_INPUT="${ROFI_INPUT}$(pango_icon 󰅖) Power: <b>Off</b>\n"
    fi 

    if jq -e ".pairable" <<< "${TOTAL_STATUS}" > /dev/null; then 
        ROFI_INPUT="${ROFI_INPUT}$(pango_icon ) Pairable: <b>On</b>\n"
    else 
        ROFI_INPUT="${ROFI_INPUT}$(pango_icon 󰅖) Pairable: <b>Off</b>\n"
    fi 

    if jq -e ".discoverable" <<< "${TOTAL_STATUS}" > /dev/null; then 
        ROFI_INPUT="${ROFI_INPUT}$(pango_icon ) Discoverable: <b>On</b>\n"
    else 
        ROFI_INPUT="${ROFI_INPUT}$(pango_icon 󰅖) Discoverable: <b>Off</b>\n"
    fi 

    # if jq -e ".scanning" <<< "$TOTAL_STATUS" > /dev/null; then 
    #     ROFI_INPUT="${ROFI_INPUT}$(pango_icon ) Scanning: <b>On</b>\n"
    # else 
    #     ROFI_INPUT="${ROFI_INPUT}$(pango_icon 󰅖) Scanning: <b>Off</b>\n"
    # fi 
    
    ROFI_INPUT="${ROFI_INPUT}$(pango_icon 󰂳) Bluetooth devices menu\n"

    CONNECTED_DEVICES=$(jq "[.[] | select(.connected == true)] | length" <<< "$(devices_list)")

    ROFI_MESSAGE="<b>${CONNECTED_DEVICES}</b> connected bluetooth device"
    if (( CONNECTED_DEVICES > 1 )); then 
        ROFI_MESSAGE="${ROFI_MESSAGE}s"
    fi

    variant=$(echo -en "${ROFI_INPUT}" | rofi -markup-rows -config "$HOME/.config/rofi/modules/controls_config.rasi"\
        -markup-rows -i -dmenu -p "Bluetooth:" -no-custom -format 'i' -mesg "${ROFI_MESSAGE}" -l $((4 + DEVICES_COUNT )) )

    if [ ! $variant ]; then
        exit;
    fi
    case $variant in 
        0) toggle_power "$(jq ".powered" <<< "${TOTAL_STATUS}" | sed -e "s/true/off/g" -e "s/false/on/g")" ;; 
        1) toggle_pairable "$(jq ".powered" <<< "${TOTAL_STATUS}" | sed -e "s/true/off/g" -e "s/false/on/g")" ;; 
        2) toggle_discoverable "$(jq ".powered" <<< "${TOTAL_STATUS}" | sed -e "s/true/off/g" -e "s/false/on/g")" ;; 
        3) devices_menu
    esac 
}

function devices_menu() {
    DEVICES_LIST=$(devices_list)
    DEVICES_COUNT=$(jq ". | length" <<< "${DEVICES_LIST}")

    ROFI_MESSAGE="${DEVICES_COUNT} founded device"
    if (( DEVICES_COUNT > 1 )); then 
        ROFI_MESSAGE="${ROFI_MESSAGE}s"
    fi

    ROFI_INPUT=""
    for DEVICE_IDX in $(seq 0 $((DEVICES_COUNT - 1)) )
    do
        DEVICE_NAME=$(jq ".[$DEVICE_IDX].name" <<< "${DEVICES_LIST}" | sed "s/\"//g")
        
        if jq -e ".[$DEVICE_IDX].connected" <<< "${DEVICES_LIST}" > /dev/null; then 
            DEVICE_ICON="󰂱"
            
            BATTERY=$(jq ".[$DEVICE_IDX].battery" <<< "${DEVICES_LIST}")
            if [ "${BATTERY}" != "null" ]; then 
                if   (( BATTERY <= 12 )); then 
                    BATTERY_SPAN="<span color=\"${ERROR_COLOR}\"><i> ${BATTERY}</i></span>"
                elif (( BATTERY<= 37 )); then 
                    BATTERY_SPAN="<span color=\"${WARNING_COLOR}\"><i> ${BATTERY}</i></span>"
                elif (( BATTERY <= 62 )); then 
                    BATTERY_SPAN="<i> ${BATTERY}</i>"
                elif (( BATTERY <= 87 )); then 
                    BATTERY_SPAN="<i> ${BATTERY}</i>"
                elif (( BATTERY <= 100 )); then 
                    BATTERY_SPAN="<i> ${BATTERY}</i>"
                fi
            fi 

            CONNECTION="(connected ${BATTERY_SPAN})"

        else 
            DEVICE_ICON="󰂯"
            CONNECTION=""
        fi

        ROFI_INPUT="${ROFI_INPUT}$(pango_icon "${DEVICE_ICON}") ${DEVICE_NAME} <b>$CONNECTION</b>\n"
    done

    ROFI_INPUT="${ROFI_INPUT}$(pango_icon 󰑓 ) Scan for devices\n"

    variant=$(echo -en "${ROFI_INPUT}" | rofi -markup-rows -config "$HOME/.config/rofi/modules/controls_config.rasi"\
        -i -dmenu -p "Bluetooth:" -no-custom -format 'i' -mesg "${ROFI_MESSAGE}" -l $((DEVICES_COUNT + 1)) )

    if [ ! $variant ]; then
        exit
    fi
    if (( variant == DEVICES_COUNT)); then 
        toggle_scan on 
        @0
    elif (( variant <= DEVICES_COUNT )); then
        SELECTED_MAC=$(jq ".[$variant].id" <<< "${DEVICES_LIST}" | sed "s/\"//g")
        
        if jq -e ".[$variant].connected" <<< "${DEVICES_LIST}" > /dev/null; then 
            disconnect_device "${SELECTED_MAC}"  
        else
            connect_device "${SELECTED_MAC}"
        fi 
    fi
}

case $1 in
    "main") main_menu ;;
    "devices") devices_menu ;;
    *) exit ;;
esac
