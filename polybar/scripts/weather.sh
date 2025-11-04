#!/usr/bin/env sh

weather-info | jq -r '"\(.icon) \(.temp)°"' 

