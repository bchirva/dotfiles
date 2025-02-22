SSH_AGENT_ENV="$HOME/.ssh/agent_env"

function _start_agent {
    ssh-agent -s | head -n 2 >| $SSH_AGENT_ENV
    source $SSH_AGENT_ENV
}

if [[ -f $SSH_AGENT_ENV ]]; then
    source $SSH_AGENT_ENV

    if [[ -z $SSH_AGENT_PID || -z $(ps -A | grep "$SSH_AGENT_PID") ]]; then
        _start_agent
    fi
else
    _start_agent
fi

