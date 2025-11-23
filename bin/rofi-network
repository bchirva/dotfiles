#!/usr/bin/env bash 

if ! command -v nmcli > /dev/null ; then 
    exit 1
fi

source "${XDG_CONFIG_HOME}/shell/theme.sh"

function main_menu {
    local -r total_status=$(nmcli networking \
        | sed "s/\<enabled\>/true/; s/\<disabled\>/false/")

    local rofi_input="" rofi_message="" wifi_available=0
    if $total_status; then 
        rofi_input="$(colored-pango-icon 󰖟 ) Network: <b>On</b>\n"

        local -r device_list="$(nmcli -g DEVICE,TYPE,STATE,CONNECTION device \
            | grep -Ev ":(loopback|bridge|tun|unavailable|wifi-p2p):")"
        local -r active_connection="$(grep -m 1 -E ":connected:" <<< "$device_list")"

        if [ -n "$active_connection" ]; then
            IFS=':' read -r active_device _ _ connection_name <<< "$active_connection"
            rofi_message="Connected to <b>$connection_name</b> on <b>$active_device</b>"
        fi 

        while read -r line; do 
            IFS=':' read -r device_name device_type connection_status connection_name <<< "$line"
            connection_status="$(sed -e 's/\<connected\>/true/' -e 's/\<disconnected\>/false/' <<< "$connection_status")"
            
            case "$device_type" in
                ethernet) $connection_status && device_icon="󰈁" || device_icon="󰈂" ;;
                wifi)     $connection_status && device_icon="󰖩" || device_icon="󰖪" ;;
                *) exit ;;
            esac 

            [ -n "$connection_name" ] && connection_name="($connection_name)"

            rofi_input+="$(colored-pango-icon "$device_icon") $device_name: <b>$(sed "s/true/On/ ; s/false/Off/" <<< "$connection_status")</b> <i>$connection_name</i>\n"
        done <<< "$device_list"

        if cut -d ':' -f 2 <<< "$device_list" | grep -q "wifi"; then
            rofi_input+="$(colored-pango-icon 󱛆 ) WiFi networks menu\n"
            wifi_available=1
        fi

        rofi_input+="$(colored-pango-icon 󰑓 ) Restart NetworkManager service\n"
    else
        rofi_input="$(colored-pango-icon 󰪎 ) Network: <b>Off</b>\n"
        rofi_message="Network disabled"
    fi

    if [ -z "$rofi_message" ]; then 
        rofi_message="No connection"; 
    fi

    local -r devices_count=$(wc -l <<< "$device_list")
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
        nmcli networking "$toggle_to"
        if ! $total_status; then
            sleep 3
            main_menu 
        fi
    elif (( variant <= devices_count )); then
        IFS=':' read -r selected_device _ device_action _ <<< "$(head -n 1 <<< "$device_list")"
        device_action=$(sed "s/\<connected\>/disconnect/; s/\<disconnected\>/connect/" <<< "$device_action")
        nmcli device "$device_action" "$selected_device" 
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

    local -r known_ssid_list=$(nmcli -g NAME,TYPE connection | grep ":.*wireless")
    local -r wifi_list=$(nmcli -t -f SSID,SIGNAL,SECURITY,DEVICE,ACTIVE device wifi list \
        | grep -v "^:")

    local rofi_input="" rofi_message=""
    local wifi_ssid="" wifi_security="" wifi_signal="" wifi_signal_icon="" wifi_device="" wifi_active="" connection=""

    while read -r line; do 
        IFS=':' read -r wifi_ssid wifi_signal wifi_security wifi_device wifi_active <<< "$line"

        grep -q "^${wifi_ssid}" <<< "$known_ssid_list" && ssid_known="true" || ssid_known="false"
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

        wifi_active="$(sed "s/yes/true/; s/no/false/" <<< "$wifi_active")"
        connection=""
        if $wifi_active ; then 
            rofi_message="Connected to <b>$wifi_ssid</b> on <b>$wifi_device</b>"
            connection="@$wifi_device"
        fi 

        rofi_input+="$(colored-pango-icon "$wifi_signal_icon") $wifi_ssid <i>($wifi_security)</i> <b>$connection</b>\n"
    done <<< "$wifi_list"

    rofi_input+="$(colored-pango-icon 󰑓 ) Rescan WiFi networks\n"

    if [ -z "$rofi_message" ]; then 
        rofi_message="No connection"; 
    fi

    local -r wifi_count=$(wc -l <<< "$wifi_list")

    local -r variant=$(echo -en "$rofi_input" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p " WiFi:" \
        -mesg "$rofi_message" \
        -l $((wifi_count + 1)) )

    if [ ! "${variant}" ]; then 
        exit; 
    fi
    if (( variant == wifi_count)); then 
        nmcli device wifi rescan
        wifi_menu
    elif (( variant <= wifi_count )); then
        local -r selected_network=$(sed -n "$((variant + 1))p" <<< "$wifi_list")
        local -r selected_ssid=$(cut -d ':' -f 1 <<< "$selected_network")

        echo "$selected_network"
        echo "$selected_ssid"

        if grep -q "^$selected_ssid" <<< "$known_ssid_list" ; then 
            if "$(sed "s/^\([^:]*:\)*//; s/yes/true/; s/no/false/" <<< "$selected_network" )"; then 
                nmcli connection down "$selected_ssid"
            else "$(cut -f 4 <<< "$wifi_list")"
                nmcli connection up "$selected_ssid"
            fi
        else 
            local -r ssid_password=$(rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-input.rasi" \
                -dmenu -password \
                -p " " \
                -mesg "Password for WiFi network <b>$selected_ssid</b>" )
            nmcli device wifi connect "$selected_ssid" "$ssid_password"
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
