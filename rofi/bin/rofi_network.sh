#!/usr/bin/env bash 

source "${XDG_CONFIG_HOME}/shell/theme.sh"

function main_menu {
    local -r total_status=$(network-ctrl system status)

    local rofi_input="" rofi_message="" wifi_available=0
    if $total_status; then 
        rofi_input="$(colored-icon 󰖟 ) Network: <b>On</b>\n"

        local -r devices_list=$(network-ctrl device list)
        local -r active_connections=$(network-ctrl connection list)
 
        if [ -n "$active_connections" ]; then
            local -r active_device=$(sed -n "1{s/\s.*$// ; p}" <<< "$active_connections")
            local -r active_connection=$(sed -n "1{s/^.*\s// ; p}" <<< "$active_connections")
            rofi_message="Connected to <b>$active_connection</b> on <b>$active_device</b>"
        fi 

        while read -r line; do 
            device_name=$(cut -f 1 <<< "$line")
            device_status=$(cut -f 3 <<< "$line")
            
            case $(cut -f 2 <<< "$line") in
                ethernet) $device_status && device_icon="󰈁" || device_icon="󰈂" ;;
                wifi)     $device_status && device_icon="󰖩" || device_icon="󰖪" ;;
                *) exit ;;
            esac 

            connection=$(sed -n "/^${device_name}/p"<<< "$active_connections")
            [ -n "$connection" ] && connection="($connection)"

            rofi_input+="$(colored-icon "$device_icon") ${device_name}: <b>$(sed "s/true/On/ ; s/false/Off/" <<< "$device_status")</b> <i>$connection</i>\n"
        done <<< "$devices_list"

        if cut -f 2 <<< "$devices_list" | grep -q "wifi"; then
            rofi_input+="$(colored-icon 󱛆 ) WiFi networks menu\n"
            wifi_available=1
        fi

        rofi_input+="$(colored-icon 󰑓 ) Restart NetworkManager service\n"
    else
        rofi_input="$(colored-icon 󰪎 ) Network: <b>Off</b>\n"
        rofi_message="Network disabled"
    fi

    if [ -z "$rofi_message" ]; then 
        rofi_message="No connection"; 
    fi

    local -r devices_count=$(wc -l <<< "$devices_list")
    local -r variant=$(echo -en "$rofi_input" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "󰖟 Network:" \
        -mesg "${rofi_message}" \
        -l $((2 + devices_count + wifi_available)) )

    if [ -z "${variant}" ]; then
        exit;
    fi

    if (( variant == 0)); then 
        toggle_to=$(sed "s/true/off/ ; s/false/on/" <<< "$total_status")
        network-ctrl system toggle "$toggle_to"
        if ! $total_status; then
            sleep 3
            main_menu 
        fi
    elif (( variant <= devices_count )); then
        network-ctrl device toggle \
            "$(sed -n "${variant}{s/\s.*$// ; p}" <<< "$devices_list")" \
            "$(sed -n "${variant}{s/^\([^ ]*\s\)\{2\}// ; s/true/On/ ; s/false/Off/ ; p}" <<< "$devices_list")"
    elif (( variant == $((devices_count + 1)) )); then
        wifi_menu
    elif (( variant == $((devices_count + 2)) )); then
        pkexec systemctl restart NetworkManager
    else
        exit
    fi
}

function wifi_menu {
    local -r KNOWN_WIFI_ICONS=( "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" )
    local -r LOCKED_WIFI_ICONS=( "󰤬" "󰤡" "󰤤" "󰤧" "󰤪" )

    local -r wifi_list=$(network-ctrl wifi list)
    local -r active_connections=$(network-ctrl connection list)

    local rofi_input="" rofi_message=""
    local wifi_ssid="" wifi_security="" wifi_signal="" wifi_signal_icon="" connection

    while read -r line; do 
        wifi_ssid=$(cut -f 1 <<< "$line")
        wifi_security=$(cut -f 2 <<< "$line")
        wifi_signal=$(cut -f 3 <<< "$line")
        ssid_known=$(cut -f 4 <<< "$line")

        if   (( wifi_signal <= 12 )); then 
            $ssid_known && wifi_signal_icon=${KNOWN_WIFI_ICONS[0]} || wifi_signal_icon=${LOCKED_WIFI_ICONS[0]} 
        elif (( wifi_signal <= 37 )); then 
            $ssid_known && wifi_signal_icon=${KNOWN_WIFI_ICONS[1]} || wifi_signal_icon=${LOCKED_WIFI_ICONS[1]} 
        elif (( wifi_signal <= 62 )); then 
            $ssid_known && wifi_signal_icon=${KNOWN_WIFI_ICONS[2]} || wifi_signal_icon=${LOCKED_WIFI_ICONS[2]} 
        elif (( wifi_signal <= 87 )); then 
            $ssid_known && wifi_signal_icon=${KNOWN_WIFI_ICONS[3]} || wifi_signal_icon=${LOCKED_WIFI_ICONS[3]} 
        elif (( wifi_signal <= 100 )); then 
            $ssid_known && wifi_signal_icon=${KNOWN_WIFI_ICONS[4]} || wifi_signal_icon=${LOCKED_WIFI_ICONS[4]} 
        fi

        connection=$(sed -n "/$wifi_ssid/{s/\s.*$// ; p}" <<< "$active_connections" )
        if [ -n "$connection" ]; then 
            rofi_message="Connected to <b>$wifi_ssid</b> on <b>$connection</b>"
            connection="@$connection"
        fi 

        rofi_input+="$(colored-icon "$wifi_signal_icon") $wifi_ssid <i>($wifi_security)</i> <b>$connection</b>\n"
    done <<< "$wifi_list"

    rofi_input+="$(colored-icon 󰑓 ) Rescan WiFi networks\n"

    if [ -z "$rofi_message" ]; then 
        rofi_message="No connection"; 
    fi

    local -r wifi_count=$(wc -l <<< "$wifi_list")

    local -r variant=$(echo -en "$rofi_input" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p " WiFi:" \
        -mesg "${rofi_message}" \
        -l $((wifi_count + 1)) )

    if [ ! "${variant}" ]; then 
        exit; 
    fi
    if (( variant == wifi_count)); then 
        nmcli device wifi rescan
        wifi_menu
    elif (( variant <= wifi_count )); then
        local -r selected_network=$(sed -n "$((variant + 1))p" <<< "$wifi_list")
        local -r selected_ssid=$(cut -f 1 <<< "$selected_network")

        if [ -n "$(sed -n "/${selected_ssid}/{s/\s.*$// ; p}" <<< "$active_connections")" ]; then
            network-ctrl wifi disconnect "$selected_ssid"
        elif "$(cut -f 4 <<< "$wifi_list")"; then 
            network-ctrl wifi connect "$selected_ssid"
        else 
            local -r ssid_password=$(rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-input.rasi" \
                -dmenu -password \
                -p " " \
                -mesg "Password for WiFi network <b>$selected_ssid</b>" )
            network-ctrl wifi connect "$selected_ssid" "$ssid_password"
        fi 
    fi
}

function main() {
    case $1 in
        "main") main_menu ;;
        "wifi") wifi_menu ;;
        *) exit 2 ;;
    esac
}

main "$@"
