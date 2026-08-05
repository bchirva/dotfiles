manpdf() {
    echo "$@"
    command -v zathura >/dev/null && man -Tpdf "$@" | zathura -
}

sshfzf() {
    key=$(
        find "$HOME/.ssh" \( \
            -path "$HOME/.ssh/agent" -o \
            -name "agent_env" -o \
            -name "*.pub" -o \
            -name "known_hosts*" -o \
            -name "config" \
            \) -prune \
            -o -type f -print |
        fzf --prompt='SSH key> '
    ) || return 1

    ssh-add -- "$key"
}
