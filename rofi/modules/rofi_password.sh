#!/usr/bin/env bash

function main() {
    local -r passwords=$(pass list \
        | sed '1d' \
        | sed -e 's/\(└\|─\|├\)//g' -e 's/^ //g')
    local -r passwords_count=$(wc -l <<< "$passwords")

    local rofi_input=""
    while read -r line 
    do 
        rofi_input="${rofi_input}${line}\0icon\x1fdialog-password-panel\n"
    done <<< "$passwords"
    rofi_input="${rofi_input}Generate new password\n"


    local -r variant=$(echo -en "$rofi_input" \
        | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
        -markup-rows -i -dmenu -p "Password:" -no-custom -format 'i' -mesg "$ROFI_MESSAGE" \
        -l $(( passwords_count > 20 ? 20 : $(( passwords_count + 1)) )) )

    if [ ! "${variant}" ]; then
        exit;
    elif (( variant == passwords_count )); then 
        local -r password_service=$(rofi -config "$HOME/.config/rofi/modules/input_config.rasi" -dmenu -p "New password for:") 
        pass generate "${password_service}" 20
    else 
        local -r selected_service="$(sed -n "${variant}" <<< "${passwords}")"
        pass -c "${selected_service}"
        notify-send -u normal -i dialog-password-panel "Password copied" "Password for ${selected_service} copied to clipboard"
    fi
}

main "$@"

