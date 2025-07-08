#!/usr/bin/env bash

function main {
    local -r WALLPAPERS_FOLDER="${HOME}/Images/wallpapers"

    function echo_wallpapers {
        while IFS= read -r -d '' f; do
            echo -en "$(basename "$f")\0icon\x1f$f\n"
        done < <( find "${WALLPAPERS_FOLDER}" -regextype posix-extended -type f -regex '.*\.(png|jpg|jpeg)' -print0 )
    }

    local -r variant="$(echo_wallpapers | rofi -config "${XDG_CONFIG_HOME}/rofi/images-board.rasi" \
        -dmenu -no-custom \
        -p "󰸉 Wallpapers:" \
        -l 4)"

    if [[ -n "${variant}" ]]; then 
        xrandr --listmonitors | awk -F ':' 'NR>1 {gsub(/^ +| +$/, "", $1); print $1}' | \
            while read -r head; do 
                nitrogen --head="${head}" --save --set-centered "${WALLPAPERS_FOLDER}/${variant}" 
            done 
    fi

}

main "$@"
