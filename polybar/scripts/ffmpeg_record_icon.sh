#!/usr/bin/env sh

main() {
    if [ -f "${XDG_RUNTIME_DIR}/ffmpeg.record.pid" ]; then 
        printf '%s\n' ""
    else 
        printf '%s\n' " "
    fi 
}

main "$@"
