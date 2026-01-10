export PATH="$HOME/.local/bin:$PATH"

export XDG_CACHE_HOME=$HOME/.cache 
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share 
export XDG_RUNTIME_DIR=/run/user/$UID
export XDG_STATE_HOME=$HOME/.local/state

export CARGO_HOME=$XDG_DATA_HOME/cargo
export CUDA_CACHE_PATH=$XDG_CACHE_HOME/nv
export CONAN_HOME=$XDG_DATA_HOME/conan2
export DEVPOD_HOME=$XDG_CACHE_HOME/devpod
export DOCKER_CONFIG=$XDG_DATA_HOME/docker
export FFMPEG_DATADIR=$XDG_DATA_HOME/ffmpeg
export FZF_DEFAULT_OPTS_FILE=$XDG_CONFIG_HOME/fzf/fzfrc
export GOMODCACHE=$XDG_CACHE_HOME/go/mod
export GOPATH=$XDG_DATA_HOME/go
export MACHINE_STORAGE_PATH=$XDG_DATA_HOME/docker/docker-machine
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NVM_DIR=$XDG_DATA_HOME/nvm
export PASSWORD_STORE_DIR=$XDG_DATA_HOME/password-store
export PYENV_ROOT=$XDG_DATA_HOME/pyenv
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export TERMINFO=$XDG_DATA_HOME/terminfo
export TERMINFO_DIRS=$XDG_DATA_HOME/terminfo:/usr/share/terminfo
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
export SSH_ASKPASS=rofi-askpass
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export WGETRC="$XDG_CONFIG_HOME/wgetrc"

export EDITOR="nvim"

[ -f "$HOME/.private_env" ] && . "$HOME/.private_env"

