export PATH="$HOME/.local/bin:$PATH"

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache 
export XDG_DATA_HOME=$HOME/.local/share 
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=/run/user/$UID

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export CARGO_HOME=$XDG_DATA_HOME/cargo
export CONAN_HOME=$XDG_DATA_HOME/conan2
export DEVPOD_HOME=$XDG_CACHE_HOME/devpod
export DOCKER_CONFIG=$XDG_DATA_HOME/docker
export FFMPEG_DATADIR=$XDG_DATA_HOME/ffmpeg
export FZF_DEFAULT_OPTS_FILE=$XDG_CONFIG_HOME/fzf/fzfrc
export GOMODCACHE=$XDG_CACHE_HOME/go/mod
export GOPATH=$XDG_DATA_HOME/go
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc":"$XDG_CONFIG_HOME/gtk-2.0/gtkrc.mine"
export MACHINE_STORAGE_PATH=$XDG_DATA_HOME/docker/docker-machine
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NVM_DIR=$XDG_DATA_HOME/nvm
export PASSWORD_STORE_DIR=$XDG_DATA_HOME/password-store
export PYENV_ROOT=$XDG_DATA_HOME/pyenv
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
export SSH_ASKPASS=$XDG_CONFIG_HOME/rofi/modules/rofi_askpass.sh

export BROWSER="zen"
export EDITOR="nvim"
export TERMINAL="kitty"
export VISUAL="nvim"

export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=kvantum

[ -f "$HOME/.private_env" ] && . "$HOME/.private_env"
