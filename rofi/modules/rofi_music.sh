#!/usr/bin/env bash

source ${XDG_CONFIG_HOME}/theme.sh

function escape_pango {
    echo "$1" | sed \
        -e 's/&/&amp;/g' \
        -e 's/</&lt;/g' \
        -e 's/>/&gt;/g' \
        -e 's/"/&quot;/g' \
        -e "s/'/&apos;/g"
}

function main {
    local -r current_track="$(mpc --format "%artist%:%album%:%title%" current)"
    local -r queue=$(mpc playlist)
    IFS=':' read -r state_opt random_opt repeat_opt <<< "$(mpc status "%state%:%random%:%repeat%")"

    local rofi_input
    local line_idx=0
    if [[ -n "${queue}" ]] ; then

        if [[ "${state_opt}" == "playing" ]]; then 
            rofi_input+="$(colored-icon pango 󰏤 ) Pause\n"
        else 
            rofi_input+="$(colored-icon pango 󰐊 ) Play\n"
        fi
        local -r play_line=$(( line_idx ))
        (( line_idx+=1))

        if [[ -n "${current_track}" ]]; then 
            IFS=':' read -r artist album title <<< "${current_track}"
            local -r rofi_message="<b>$(escape_pango "${title}")</b>"$'\n'"<i>󰀄 ${artist}</i>"$'\n'"<i>󰀥 ${album}</i>"

            rofi_input+="$(colored-icon pango 󰒮 ) Previous track\n"
            rofi_input+="$(colored-icon pango 󰒭 ) Next track\n"

            local -r next_line=1
            local -r prev_line=2
            (( line_idx += 2))
        else 
            local -r rofi_message="Playlist is stopped"$'\n'"$(wc -l <<< "${queue}") tracks in queue"
        fi
    else 
        local -r rofi_message="Current playlist is empty"
        local -r play_line=-1 prev_line=-1 next_line=-1 
    fi 

    rofi_input+="$(colored-icon pango 󰑖 ) Repeat\n"
    local -r repeat_line=$(( line_idx ))
    (( line_idx+=1 ))

    rofi_input+="$(colored-icon pango 󰒟 ) Random\n"
    local -r random_line=$(( line_idx ))
    (( line_idx+=1 ))

    local highlight_rows=()
    [[ "${repeat_opt}" == "on" ]] && highlight_rows+=( "${repeat_line}" )
    [[ "${random_opt}" == "on" ]] && highlight_rows+=( "${random_line}" )
    local -r row_modifiers=(-a "$(IFS=","; echo "${highlight_rows[*]}")")

    local -r variant=$(echo -en "${rofi_input}" | rofi -config "${XDG_CONFIG_HOME}/rofi/modules/controls_music.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format "i" \
        -mesg "${rofi_message}" \
        "${row_modifiers[@]}" \
        -l ${line_idx})

    if [[ -z "${variant}" ]]; then 
        exit 1
    fi

    case "${variant}" in 
    $(( play_line )) )
        if [[ "${state_opt}" == "playing" ]]; then 
            mpc pause
        else 
            mpc play
        fi
        ;;
    $(( prev_line )) ) mpc prev ;;
    $(( next_line )) ) mpc next ;;
    $(( repeat_line )) ) mpc repeat ;;
    $(( random_line )) ) mpc random ;;
    *) exit 2 ;;
    esac 
}

main "$@"
