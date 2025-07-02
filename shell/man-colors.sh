function man {
    source ${XDG_CONFIG_HOME}/shell/theme.sh

    LESS_TERMCAP_me=$'\e[00m' \
    LESS_TERMCAP_ue=$'\e[00m' \
    LESS_TERMCAP_se=$'\e[00m' \
    LESS_TERMCAP_mb=$'\e[01;'${SECONDARY_COLOR_ANSI}'m' \
    LESS_TERMCAP_us=$'\e[01;'${SECONDARY_COLOR_ANSI}'m' \
    LESS_TERMCAP_md=$'\e[01;'${PRIMARY_COLOR_ANSI}'m' \
    LESS_TERMCAP_so=$'\e[01;07m' \
    GROFF_NO_SGR=1 \
    command man "$@"
}

