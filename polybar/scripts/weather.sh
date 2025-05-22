#!/usr/bin/env bash

function main() {
    local -r weather=$(weather-info)
    jq -r '"\(.icon) \(.temp)°"' <<< "${weather}"
}

main "$@"

