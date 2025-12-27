#!/usr/bin/env bash 

if ! command -v nmcli > /dev/null ; then 
    exit 1
fi

source "${XDG_CONFIG_HOME}/shell/theme.sh"

function main_menu {
    local -r total_status=$(nmcli networking \
        | sed "s/\<enabled\>/true/; s/\<disabled\>/false/")

    local rofi_input="" rofi_message="" idx=1
    if $total_status; then 
        rofi_input="$(colored-pango-icon 󰖟 ) Network: <b>On</b>\n"

        local -r device_list="$(nmcli -g DEVICE,TYPE,STATE,CONNECTION device \
            | grep -Ev ":(loopback|bridge|tun|unavailable|wifi-p2p):")"
        local -r devices_count=$(wc -l <<< "$device_list")
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
        idx=$((devices_count + 1))

        if cut -d ':' -f 2 <<< "$device_list" | grep -q "wifi"; then
            rofi_input+="$(colored-pango-icon 󱛆 ) WiFi networks menu\n"
            local -r wifi_idx=$idx
            (( idx+=1 ))
        fi

        if command -v sing-box >/dev/null; then
            rofi_input+="$(colored-pango-icon 󰒃) Proxy\n"
            local -r proxy_idx=$idx
            (( idx+=1 ))
        fi

        rofi_input+="$(colored-pango-icon 󰑓 ) Restart NetworkManager service\n"
        local -r restart_idx=$idx
        (( idx+=1 ))
    else
        rofi_input="$(colored-pango-icon 󰪎 ) Network: <b>Off</b>\n"
        rofi_message="Network disabled"
    fi

    if [ -z "$rofi_message" ]; then 
        rofi_message="No connection"; 
    fi

    local -r variant=$(echo -en "$rofi_input" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "󰖟 Network:" \
        -mesg "${rofi_message}" \
        -l "$idx" )

    if [ -z "${variant}" ]; then
        exit;
    fi

    case $variant in 
        0)
            toggle_to=$(sed "s/true/off/ ; s/false/on/" <<< "$total_status")
            nmcli networking "$toggle_to"
            if ! $total_status; then
                sleep 3
                main_menu 
            fi
            ;;
        $((wifi_idx)) )   wifi_menu ;;
        $((proxy_idx)) )   proxy_menu ;;
        $((restart_idx)) ) pkexec systemctl restart NetworkManager ;;
        *) 
            IFS=':' read -r selected_device _ device_action _ <<< "$(head -n 1 <<< "$device_list")"
            device_action=$(sed "s/\<connected\>/disconnect/; s/\<disconnected\>/connect/" <<< "$device_action")
            nmcli device "$device_action" "$selected_device" 
            ;;
    esac 
}

function proxy_menu {
    local -r SERVICE_NAME="sing-box@${USER}.service"
    local -r SING_BOX_CONFIG="$XDG_CONFIG_HOME/sing-box/config.json"
    local -r CLIENT_CONFIGS=( "$(find "$XDG_CONFIG_HOME/sing-box/clients/" -maxdepth 1 \( -type f -o -type l \) -name "*.json" )" ) 

    local rofi_input="" rofi_message="" toggle_line=0 row_modifiers=()

    if [ -L "$SING_BOX_CONFIG" ]; then 
        local -r ACTIVE_PROXY=$(readlink "$SING_BOX_CONFIG")
    fi 

    if systemctl -q is-active "$SERVICE_NAME" >/dev/null ; then 
        rofi_input+="$(colored-pango-icon ) Turn off\n"
    else 
        rofi_message="Proxy is off."
        if [ -e "$SING_BOX_CONFIG" ] && sing-box check -c "$SING_BOX_CONFIG" ; then 
            rofi_input+="$(colored-pango-icon ) Turn on\n"
        fi
    fi
     
    if [ -n "$rofi_input" ]; then 
        toggle_line=1
    fi

    for client in "${CLIENT_CONFIGS[@]}"; do
        if [ "$ACTIVE_PROXY" == "$client" ]; then 
            row_modifiers=( -a "$(grep -n "$ACTIVE_PROXY" <<< "${CLIENT_CONFIGS[@]}" | cut -d ':' -f 1)" )
            rofi_message="Active proxy client: $(basename "$ACTIVE_PROXY")"
        fi 

        rofi_input+="$(colored-pango-icon 󰒃) $(basename "$client")\n"
    done 

    local -r variant=$(echo -en "$rofi_input" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "󰙁 Proxy:" \
        -mesg "$rofi_message" \
        "${row_modifiers[@]}" \
        -l $(( $(wc -l <<< "${CLIENT_CONFIGS[@]}") + toggle_line )) )

    if [ -z "$variant" ]; then
        exit 1
    fi
    if (( variant == 0 )) && (( toggle_line == 1 )); then 
        if systemctl -q is-active "$SERVICE_NAME" >/dev/null ; then 
            systemctl stop "$SERVICE_NAME"
        else 
            systemctl start "$SERVICE_NAME"
        fi
    else 
        local -r selected_client="$(sed -n "$((variant - toggle_line + 1))p" <<< "${CLIENT_CONFIGS[@]}")"
        ln -sf "$selected_client" "$SING_BOX_CONFIG"
        systemctl restart "$SERVICE_NAME"
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
        "proxy") proxy_menu ;;
        *) exit 2 ;;
    esac
}

main "$@"
