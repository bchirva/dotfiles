#!/usr/bin/env bash

source $HOME/.config/theme.sh

function main() {
    function rofi_input() {
        echo -en "$(colored-icon pango 󰇀 ) Shot focused window\n"
        echo -en "$(colored-icon pango 󰍹 ) Shot whole screen\n"
        echo -en "$(colored-icon pango 󰒉 ) Shot selected area or window\n"
    }

    local -r variant=$(rofi_input \
        | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
        -markup-rows -no-custom -i -dmenu \
        -format "i" \
        -p "Screen capture" \
        -l 3)


    if [[ $variant ]]; then
        case $variant in
            0) 
                sleep 0.5
                screenshot-cmd focused ;;
            1) 
                readarray -t screens <<< "$(xrandr \
                    | grep "\bconnected\b" \
                    | awk '{print $1}')"

                local rofi_input_screens
                for screen in "${screens[@]}"; do 
                    rofi_input_screens+="$(colored-icon pango 󰍹 ) ${screen}\n"
                done 

                if (( ${#screens[@]} == 1 )); then 
                    local -r variant_screen=0
                else 
                    local -r variant_screen=$(echo -en "${rofi_input_screens}" \
                        | rofi -config "${XDG_CONFIG_HOME}/rofi/modules/controls_config.rasi" \
                            -markup-rows -no-custom -i -dmenu \
                            -format "i" \
                            -p "Screenshot of..." \
                            -l ${#screens[@]})
                fi

                if [[ $variant_screen ]]; then 
                    local -r selected_screen="${screens[${variant_screen}]}"
                    sleep 0.5
                    screenshot-cmd screen "${selected_screen}"
                fi 
                ;;
            2) 
                sleep 0.5
                screenshot-cmd select ;;
            *) exit ;;
        esac
    fi
}

main "$@"
