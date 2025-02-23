function man {
    source $ZDOTDIR/plugins/man-colors/lesscolors

    LESS_TERMCAP_me=$'\e[00m' \
    LESS_TERMCAP_ue=$'\e[00m' \
    LESS_TERMCAP_se=$'\e[00m' \
    LESS_TERMCAP_mb=$'\e[01;'${LESS_UNDERLINE_COLOR}'m' \
    LESS_TERMCAP_us=$'\e[01;'${LESS_UNDERLINE_COLOR}'m' \
    LESS_TERMCAP_md=$'\e[01;'${LESS_BOLD_COLOR}'m' \
    LESS_TERMCAP_so=$'\e[01;07m' \
    GROFF_NO_SGR=1 \
    command man "$@"
}

