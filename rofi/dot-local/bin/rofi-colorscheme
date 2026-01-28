#!/usr/bin/env bash

source "$XDG_CONFIG_HOME/shell/theme.sh"

function main() {
    local -r colorschemes_dir="$(dirname "$(readlink -f "$XDG_CONFIG_HOME/rofi/colors.rasi")")/.."

    readarray -t schemes <<< "$(find "$colorschemes_dir" -maxdepth 1 -mindepth 1 -type d -printf '%f\n')"

    function rofi_input(){
        for i in ${!schemes[*]} 
        do
            echo -en "$(colored-pango-icon  ) ${schemes[$i]}\n"
        done
    }

    local -r active_scheme=$(readlink "$colorschemes_dir/active")
    for i in ${!schemes[*]}
    do
        if [ "${schemes[$i]}" = "$active_scheme" ]; then
            local -r row_modifiers=(-a "$i" -selected-row "$i")
        fi
    done

    local -r variant=$(rofi_input \
        | rofi -config "$XDG_CONFIG_HOME/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format "i" \
        -p " Colorshemes:" \
        "${row_modifiers[@]}" \
        -l ${#schemes[@]} )

    if [ -n "$variant" ]; then
        local -r new_scheme=${schemes[$variant]}

        rm "$colorschemes_dir/active"
        ln -srf "$colorschemes_dir/$new_scheme" "$colorschemes_dir/active"

        xrdb -merge ~/.Xresources

        local -r processes=(polybar dunst)
        for process in "${processes[@]}"; do 
            if pgrep "$process"; then 
                killall "$process"
            fi 
        done 

        if pgrep openbox > /dev/null; then 
            openbox --restart
        fi
        if pgrep bspwm > /dev/null ; then
            bspc wm -r
        fi
    fi
}

main "$@"
