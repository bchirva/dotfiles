source $HOME/.config/polybar/scripts/utils_scripts/weather.sh

WEATHER=$(weather_json)
jq -r '"\(.icon) \(.temp)°"' <<< "${WEATHER}"
