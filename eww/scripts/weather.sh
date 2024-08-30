#!/bin/bash

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
icon=$(weather_icon $(jq ".weather[].icon" <<< $weather | sed "s/\"//g"))

echo $weather | jq "{ temp: .main.temp, description: .weather[].main, detailed: .weather[].description, icon: \"$icon\", wind: .wind.speed, humidity: .main.humidity }"

