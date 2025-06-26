#!/usr/bin/env bash

source "${XDG_CONFIG_HOME}/rofi/colors.sh"

function main() {
    function rofi_input() {
        echo -en "$(colored-icon pango 󰇀 ) Shot focused window\n"
        echo -en "$(colored-icon pango 󰍹 ) Shot whole screen\n"
        echo -en "$(colored-icon pango 󰒉 ) Shot selected area or window\n"
        echo -en "$(colored-icon pango  ) Record screen\n"
    }

    function select_screen() {
        readarray -t screens <<< "$(xrandr \
            | grep "\bconnected\b" \
            | awk '{print $1, ($3 == "primary" ? 0 : 1)}' \
            | sort -k2,2 -k1 \
            | awk '{print $1}')"

        local rofi_input_screens
        for screen in "${screens[@]}"; do 
            rofi_input_screens+="$(colored-icon pango 󰍹 ) ${screen}\n"
        done 

        if (( ${#screens[@]} == 1 )); then 
            local -r variant_screen=0
        else 
            local -r variant_screen=$(echo -en "${rofi_input_screens}" \
                | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
                    -markup-rows -no-custom -i -dmenu \
                    -format "i" \
                    -p "Select screen" \
                    -l ${#screens[@]})
        fi

        if [[ $variant_screen ]]; then 
            echo "${screens[${variant_screen}]}"
        fi
    }

    local -r variant=$(rofi_input \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -no-custom -i -dmenu \
        -format "i" \
        -p "Screen capture" \
        -l 4)


    if [[ $variant ]]; then
        case $variant in
            0) 
                sleep 0.5
                screen-capture-cmds focused 
                ;;
            1) 
                local -r selected_screen="$(select_screen)"
                sleep 0.5
                screen-capture-cmds screen "${selected_screen}"
                ;;
            2) 
                sleep 0.5
                screen-capture-cmds select 
                ;;
            3)
                if [[ ! -f ${XDG_RUNTIME_DIR}/ffmpeg.record.pid ]]; then 
                    local -r selected_screen="$(select_screen)"
                    sleep 0.5
                    screen-capture-cmds record "${selected_screen}"
                else 
                    screen-capture-cmds record
                fi
                ;;
            *) exit ;;
        esac
    fi
}

main "$@"
