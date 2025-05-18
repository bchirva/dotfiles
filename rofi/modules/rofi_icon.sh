source $HOME/.config/rofi/theme/theme.sh

function pango_icon() {
    ICON=$1
    # COLOR=$2
    COLOR="${2:-$ACCENT_COLOR}"
    echo -en "<span size=\"150%\" rise=\"-3pt\" color=\"${COLOR}\">${ICON} </span>"
}
