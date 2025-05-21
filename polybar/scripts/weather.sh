WEATHER=$(weather-info)
jq -r '"\(.icon) \(.temp)°"' <<< "${WEATHER}"
