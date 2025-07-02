#!/usr/bin/env bash

source "${XDG_CONFIG_HOME}/shell/theme.sh"

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
    IFS=':' read -r state_opt random_opt repeat_opt consume_opt <<< "$(mpc status "%state%:%random%:%repeat%:%consume%")"

    local rofi_input
    local line_idx=0
    if [[ -n "${queue}" ]] ; then

        if [[ "${state_opt}" == "playing" ]]; then 
            local -r play_line="$(colored-icon pango 󰏤 ) Pause\n"
        else 
            local -r play_line+="$(colored-icon pango 󰐊 ) Play\n"
        fi

        if [[ -n "${current_track}" ]]; then 
            rofi_input+="$(colored-icon pango 󰒮 ) Previous track\n"
            local -r prev_line_idx=$(( line_idx ))
            (( line_idx+=1))

            rofi_input+="${play_line}"
            local -r play_line_idx=$(( line_idx ))
            (( line_idx+=1))

            rofi_input+="$(colored-icon pango 󰒭 ) Next track\n"
            local -r next_line_idx=$(( line_idx ))
            (( line_idx+=1))

            IFS=':' read -r artist album title <<< "${current_track}"
            local -r rofi_message="<b>$(escape_pango "${title}")</b>"$'\n'"<i>(󰀄 ${artist} / 󰀥 ${album})</i>"
        else 
            rofi_input+="${play_line}"
            local -r play_line_idx=$(( line_idx ))
            (( line_idx+=1 ))

            local -r rofi_message="Playlist is stopped"$'\n'"$(wc -l <<< "${queue}") tracks in queue"
            local -r prev_line_idx=-1 next_line_idx=-1
        fi

        rofi_input+="$(colored-icon pango 󰲸 ) Current playlist\n"
        local -r playlist_line_idx=$(( line_idx ))
        (( line_idx+=1))
    else 
        local -r rofi_message="Current playlist is empty"
        local -r play_line_idx=-1 prev_line_idx=-1 next_line_idx=-1 playlist_line_idx=-1
    fi 

    rofi_input+="$(colored-icon pango 󰑖 ) Repeat\n"
    local -r repeat_line_idx=$(( line_idx ))
    (( line_idx+=1 ))

    rofi_input+="$(colored-icon pango 󰒟 ) Random\n"
    local -r random_line_idx=$(( line_idx ))
    (( line_idx+=1 ))

    rofi_input+="$(colored-icon pango  ) Consume\n"
    local -r consume_line_idx=$(( line_idx ))
    (( line_idx+=1 ))

    local highlight_rows=()
    [[ "${repeat_opt}" == "on" ]] && highlight_rows+=( "${repeat_line_idx}" )
    [[ "${random_opt}" == "on" ]] && highlight_rows+=( "${random_line_idx}" )
    [[ "${consume_opt}" == "on" ]] && highlight_rows+=( "${consume_line_idx}" )
    if (( play_line_idx != -1 )); then 
        local -r selected_play_line=(-selected-row $(( play_line_idx)) )
    fi 
    local -r row_modifiers=(-a "$(IFS=","; echo "${highlight_rows[*]}")" "${selected_play_line[@]}")

    local -r variant=$(echo -en "${rofi_input}" | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format "i" \
        -p "󰎄 Music:" \
        -mesg "${rofi_message}" \
        "${row_modifiers[@]}" \
        -l ${line_idx})

    if [[ -z "${variant}" ]]; then 
        exit 1
    fi

    case "${variant}" in 
    $(( play_line_idx )) )
        if [[ "${state_opt}" == "playing" ]]; then 
            mpc pause
        else 
            mpc play
        fi
        ;;
    $(( playlist_line_idx )) )
        local -r MAX_PLAYLIST_LINES=15
        local -r playlist_tracks="$(mpc --format "%title% <i>(%artist% - %album%)</i>" playlist)"
        local -r playlist_size=$(grep -cv '^$' <<< "${playlist_tracks}")
        local -r current_playlist_position=$(( $(mpc status "%songpos%") - 1 ))

        local rofi_input_playlist=""
        while read -r line 
        do 
            if [[ -n "${line}" ]]; then 
                rofi_input_playlist+="$(colored-icon pango 󰝚 ) ${line}\n"
            fi
        done <<< "${playlist_tracks}"

        local -r variant_track=$(echo -en "${rofi_input_playlist}" | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-wide-column.rasi" \
            -markup-rows -i -dmenu -no-custom \
            -format "i" \
            -p "󰎄 Playlist" \
            -a "${current_playlist_position}" \
            -selected-row "${current_playlist_position}" \
            -l $(( playlist_size > MAX_PLAYLIST_LINES ? MAX_PLAYLIST_LINES : playlist_size ))
        )

        if [[ -n ${variant_track} ]]; then 
            mpc play $(( variant_track + 1 ))
        fi 
    ;;
    $(( prev_line_idx )) ) mpc prev ;;
    $(( next_line_idx )) ) mpc next ;;
    $(( repeat_line_idx )) ) mpc repeat ;;
    $(( random_line_idx )) ) mpc random ;;
    $(( consume_line_idx )) ) mpc consume ;;
    *) exit 2 ;;
    esac 
}

main "$@"
