# Nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  

# Pyenv
if [ -d $PYENV_ROOT/bin ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --detect-shell -)"
fi

# Homebrew
[ -s "/home/linuxbrew/.linuxbrew/bin/brew" ] && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv "$(ps -p $$ -o comm=)")"
