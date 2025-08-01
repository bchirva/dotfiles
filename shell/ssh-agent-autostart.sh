readonly SSH_AGENT_ENV="${XDG_RUNTIME_DIR}/ssh-agent-env"

function _start_agent {
    ssh-agent -s | head -n 2 >| "${SSH_AGENT_ENV}"
    source "${SSH_AGENT_ENV}"
}

if [[ -f "${SSH_AGENT_ENV}" ]]; then
    source "${SSH_AGENT_ENV}"
    if [[ -z "${SSH_AGENT_PID}" ]] || ! kill -0 "${SSH_AGENT_PID}" 2>/dev/null ; then
        _start_agent
    fi
else
    _start_agent
fi
