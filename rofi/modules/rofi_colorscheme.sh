#!/usr/bin/env bash

source $HOME/.config/theme.sh

function main() {
    local -r colorschemes_dir=$HOME/Documents/dotfiles/colorschemes/build
    cd "${colorschemes_dir}" || exit 1
    readarray -t schemes <<< $(ls -1 -d */ | sed 's/\///g' | sed '/active/d')

    function rofi_input(){
        for i in ${!schemes[*]} 
        do
            echo -en "$(colored-icon pango  ) ${schemes[$i]}\n"
        done
    }

    function row_modifiers(){
        local active_scheme=$(ls -l active | awk '{print $NF}')
        for i in ${!schemes[*]}
        do
            if [[ "${schemes[$i]}" == "${active_scheme}" ]]; then
                echo -en "-a ${i} -selected-row ${i}"
            fi
        done
    }

    local variant
    variant=$(rofi_input \
        | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
        -markup-rows -i -dmenu -p "Colorshemes:" -format "i" -no-custom -l ${#schemes[@]} $(row_modifiers))

    if [[ $variant ]]; then
        variant=${schemes[$variant]}

        rm "${colorschemes_dir}"/active
        ln -srf "$colorschemes_dir/$variant" "$colorschemes_dir/active"

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
