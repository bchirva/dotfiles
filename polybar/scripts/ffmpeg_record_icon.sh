#!/usr/bin/env bash

function main {
    if [[ -f ${XDG_RUNTIME_DIR}/ffmpeg.record.pid ]]; then 
        echo ""
    else 
        echo " "
    fi 
}

main "$@"
