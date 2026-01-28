#!/usr/bin/env sh

if ! command -v jq >/dev/null || [ -z "$OPENWEATHER_KEY" ] ; then 
    echo " "
    exit 1
fi

weather_icon(){
    case $1 in
        "01d") echo "" ;;
        "02d") echo "" ;;
        "03d") echo "" ;;
        "04d") echo "" ;;
        "09d") echo "" ;;
        "10d") echo "" ;;
        "11d") echo "" ;;
        "13d") echo "" ;;
        "50d") echo "" ;;
        "01n") echo "" ;;
        "02n") echo "" ;;
        "03n") echo "" ;;
        "04n") echo "" ;;
        "09n") echo "" ;;
        "10n") echo "" ;;
        "11n") echo "" ;;
        "13n") echo "" ;;
        "50n") echo "" ;;
        *)     echo "n/a" ;;
    esac
}

weather=$(curl -s "api.openweathermap.org/data/2.5/weather?q=Yekaterinburg,ru&units=metric&appid=$OPENWEATHER_KEY")
    
temperature="$(printf '%s\n' "$weather" \
    | jq '(.main.temp | round) as $tmp | (if $tmp > 0 then "+" + ($tmp | tostring) else ($tmp | tostring) end)' \
    | sed 's/\"//g')"

icon=$(weather_icon "$(printf '%s' "$weather" | jq ".weather[].icon" | sed "s/\"//g")")

printf '%s %s\n' \
   "$icon" "${temperature}" 

