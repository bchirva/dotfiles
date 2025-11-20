#!/usr/bin/env bash

source "${XDG_CONFIG_HOME}/shell/theme.sh"

function main_menu {
    local -r total_status=$(bluetooth-ctrl status)

    local rofi_message rofi_input
    if jq -e ".powered" <<< "${total_status}" > /dev/null; then 
        rofi_input="${rofi_input}$(colored-icon ) Power: <b>On</b>\n"
    else 
        rofi_input="${rofi_input}$(colored-icon 󰅖) Power: <b>Off</b>\n"
    fi 

    if jq -e ".pairable" <<< "${total_status}" > /dev/null; then 
        rofi_input="${rofi_input}$(colored-icon ) Pairable: <b>On</b>\n"
    else 
        rofi_input="${rofi_input}$(colored-icon 󰅖) Pairable: <b>Off</b>\n"
    fi 

    if jq -e ".discoverable" <<< "${total_status}" > /dev/null; then 
        rofi_input="${rofi_input}$(colored-icon ) Discoverable: <b>On</b>\n"
    else 
        rofi_input="${rofi_input}$(colored-icon 󰅖) Discoverable: <b>Off</b>\n"
    fi 

    # if jq -e ".scanning" <<< "$TOTAL_STATUS" > /dev/null; then 
    #     ROFI_INPUT="${ROFI_INPUT}$(colored-icon ) Scanning: <b>On</b>\n"
    # else 
    #     ROFI_INPUT="${ROFI_INPUT}$(colored-icon 󰅖) Scanning: <b>Off</b>\n"
    # fi 
    
    rofi_input+="$(colored-icon 󰂳) Bluetooth devices menu\n"

    local -r connected_devices=$(jq "[.[] | select(.connected == true)] | length" <<< "$(bluetooth-ctrl device list)")

    rofi_message="<b>${connected_devices}</b> connected bluetooth device"
    if (( connected_devices > 1 )); then 
        rofi_message="${rofi_message}s"
    fi

    local -r variant=$(echo -en "${rofi_input}" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "󰂯 Bluetooth:" \
        -mesg "${rofi_message}" \
        -l 4 )

    if [ ! "${variant}" ]; then
        exit;
    fi
    case $variant in 
        0) bluetooth-ctrl power "$(jq ".powered" <<< "${total_status}" \
                | sed -e "s/true/off/g" -e "s/false/on/g")" ;; 
        1) bluetooth-ctrl pairable "$(jq ".powered" <<< "${total_status}" \
            | sed -e "s/true/off/g" -e "s/false/on/g")" ;; 
        2) bluetooth-ctrl discoverable "$(jq ".powered" <<< "${total_status}" \
            | sed -e "s/true/off/g" -e "s/false/on/g")" ;; 
        3) devices_menu
    esac 
}

function devices_menu() {
    local -r devices_list=$(bluetooth-ctrl device list)
    local -r devices_count=$(jq ". | length" <<< "${devices_list}")

    local rofi_message="${devices_count} founded device"
    if (( devices_count > 1 )); then 
        rofi_message="${rofi_message}s"
    fi

    local rofi_input=""
    local device_name device_icon battery battery_span connection
    for device_idx in $(seq 0 $((devices_count - 1)) )
    do
        device_name=$(jq ".[$device_idx].name" <<< "${devices_list}" \
            | sed "s/\"//g")
        
        if jq -e ".[$device_idx].connected" <<< "${devices_list}" > /dev/null; then 
            device_icon="󰂱"
            
            battery=$(jq ".[$device_idx].battery" <<< "${devices_list}")
            if [ "${battery}" != "null" ]; then 
                if   (( battery <= 12 )); then 
                    battery_span="<span color=\"${ERROR_COLOR}\"><i> ${battery}</i></span>"
                elif (( battery<= 37 )); then 
                    battery_span="<span color=\"${WARNING_COLOR}\"><i> ${battery}</i></span>"
                elif (( battery <= 62 )); then 
                    battery_span="<i> ${battery}</i>"
                elif (( battery <= 87 )); then 
                    battery_span="<i> ${battery}</i>"
                elif (( battery <= 100 )); then 
                    battery_span="<i> ${battery}</i>"
                fi
            fi 

            connection="(connected ${battery_span})"

        else 
            device_icon="󰂯"
            connection=""
        fi

        rofi_input="${rofi_input}$(colored-icon "${device_icon}") ${device_name} <b>$connection</b>\n"
    done

    rofi_input="${rofi_input}$(colored-icon 󰑓 ) Scan for devices\n"

    local -r variant=$(echo -en "${rofi_input}" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "󰂳 Bluetooth:" \
        -mesg "${rofi_message}" \
        -l $((devices_count + 1)) )

    if [ ! "${variant}" ]; then
        exit
    fi
    if (( variant == devices_count)); then 
        bluetooth-ctrl scan on 
        devices_menu
    elif (( variant <= devices_count )); then
        local -r selected_mac=$(jq ".[$variant].id" <<< "${devices_list}" \
            | sed "s/\"//g")
        
        if jq -e ".[$variant].connected" <<< "${devices_list}" > /dev/null; then 
            bluetooth-ctrl disconnect disconnect "${selected_mac}"  
        else
            bluetooth-ctrl device connect "${selected_mac}"
        fi 
    fi
}

function main() {
    case $1 in
        "main") main_menu ;;
        "devices") devices_menu ;;
        *) exit 2 ;;
    esac
}

main "$@"
