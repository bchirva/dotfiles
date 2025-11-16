#!/usr/bin/env sh

. "${XDG_CONFIG_HOME}/shell/theme.sh"

select_screen() {
    screens="$(xrandr --listactivemonitors \
        | sed 1d \
        | awk '{print $NF}')"

    screen_count=$(printf '%s\n' "${screens}" | wc -l )

    if [ "${screen_count}" -eq 0 ]; then 
        variant_screen=0
    else 
        rofi_input=$(printf '%s\n' "${screens}" \
            | while read -r line; do 
                printf '%s\n' "$(colored-icon pango 󰍹 ) ${line}"
            done)

        variant_screen=$(printf '%s\n' "${rofi_input}" \
            | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
                -markup-rows -no-custom -i -dmenu \
                -format "i" \
                -p "Select screen" \
                -l "${screen_count}")
    fi

    if [ -n "$variant_screen" ]; then 
        variant_screen=$((variant_screen + 1))
        printf '%s\n' "${screens}" | sed -n "${variant_screen}p"
    fi
}

rofi_str="\
$(colored-icon pango 󰇀 ) Shot focused window
$(colored-icon pango 󰍹 ) Shot whole screen
$(colored-icon pango 󰒉 ) Shot selected area or window
$(colored-icon pango  ) Record screen"

variant=$(printf '%s\n' "${rofi_str}" \
    | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
    -markup-rows -no-custom -i -dmenu \
    -format "i" \
    -p "󰹑 Screen capture:" \
    -l 4)

if [ -n "$variant" ]; then
    case $variant in
        0) 
            sleep 0.5
            screen-capture-cmds focused 
            ;;
        1) 
            selected_screen="$(select_screen)"
            sleep 0.5
            screen-capture-cmds screen "${selected_screen}"
            ;;
        2) 
            sleep 0.5
            screen-capture-cmds select 
            ;;
        3)
            if [ ! -f "${XDG_RUNTIME_DIR}/ffmpeg.record.pid" ]; then 
                selected_screen="$(select_screen)"
                sleep 0.5
                screen-capture-cmds record "${selected_screen}"
            else 
                screen-capture-cmds record
            fi
            ;;
        *) exit ;;
    esac
fi

