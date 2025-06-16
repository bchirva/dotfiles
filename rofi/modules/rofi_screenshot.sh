#!/usr/bin/env bash

source $HOME/.config/theme.sh

function main() {
    function rofi_input() {
        echo -en "$(colored-icon pango 󰒉 ) ...selected area or window\n"
        echo -en "$(colored-icon pango 󰇀 ) ...focused window\n"
        echo -en "$(colored-icon pango 󰍹 ) ...screen\n"
    }

    local -r variant=$(rofi_input \
        | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
        -markup-rows -no-custom -i -dmenu \
        -p "Screenshot of..." \
        -format "i" \
        -l 3)


    if [[ $variant ]]; then
        case $variant in
            0) 
                sleep 0.5
                screenshot-cmd select ;;
            1) 
                sleep 0.5
                screenshot-cmd focused ;;
            2) 
                readarray -t screens <<< "$(xrandr \
                    | grep "\bconnected\b" \
                    | awk '{print $1}')"

                local rofi_input_screens
                for screen in "${screens[@]}"; do 
                    rofi_input_screens="${rofi_input_screens}$(colored-icon pango 󰍹 ) ${screen}\n"
                done 

                local -r variant_screen=$(echo -en "${rofi_input_screens}" \
                    | rofi -config "${XDG_CONFIG_HOME}/rofi/modules/controls_config.rasi" \
                        -markup-rows -no-custom -i -dmenu \
                        -p "Screenshot of..." \
                        -format "i" \
                        -l ${#screens[@]})

                if [[ $variant_screen ]]; then 
                    local -r selected_screen="${screens[${variant_screen}]}"
                    sleep 0.5
                    screenshot-cmd screen "${selected_screen}"
                fi 
                ;;
            *) exit ;;
        esac
    fi
}

main "$@"
