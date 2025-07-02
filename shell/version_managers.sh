[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  

[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --detect-shell -)"
