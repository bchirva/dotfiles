#!/usr/bin/env bash

source $HOME/.config/theme.sh

function main() {
    local -r colorschemes_dir="$(readlink -f \
        "$(dirname \
        "$(readlink -f $HOME/Documents/dotfiles/colorschemes/build)")/..")/colorschemes/build/"

    readarray -t schemes <<< "$(ls -1 "${colorschemes_dir}" \
        | sed -e 's/\///g' -e '/active/d')"

    function rofi_input(){
        for i in ${!schemes[*]} 
        do
            echo -en "$(colored-icon pango  ) ${schemes[$i]}\n"
        done
    }

    function row_modifiers(){
        local -r active_scheme=$(ls -l "${colorschemes_dir}/active" | awk '{print $NF}')
        for i in ${!schemes[*]}
        do
            if [[ "${schemes[$i]}" == "${active_scheme}" ]]; then
                echo -en "-a ${i} -selected-row ${i}"
            fi
        done
    }

    local -r variant=$(rofi_input \
        | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
        -markup-rows -i -dmenu -p "Colorshemes:" -format "i" -no-custom -l ${#schemes[@]} $(row_modifiers))

    if [[ $variant ]]; then
        local -r new_scheme=${schemes[$variant]}

        rm "${colorschemes_dir}/active"
        ln -srf "${colorschemes_dir}/${new_scheme}" "${colorschemes_dir}/active"

        if pgrep polybar > /dev/null ; then
            killall polybar
        fi

        if pgrep openbox > /dev/null ; then
            openbox --restart
            polybar -c $HOME/.config/polybar/config_openbox.ini &
        fi

        if pgrep bspwm > /dev/null ; then
            bspc wm -r
            polybar -c $HOME/.config/polybar/config_bspwm.ini mainbar &
            polybar -c $HOME/.config/polybar/config_bspwm.ini auxbar &
        fi

        eww reload
        killall dunst
    fi
}

main "$@"
