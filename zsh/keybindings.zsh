#!/bin/zsh

typeset -A key
key[Home]="[H"
key[End]="[F"
key[PageUp]="[5"
key[PageDown]="[6"
key[Insert]="[2~"
key[Delete]="[3~"
key[Backspace]="^?"
key[Up]="[A"
key[Down]="[B"
key[Right]="[C"
key[Left]="[D"
key[Ctrl_Up]="[1;5A"
key[Ctrl_Down]="[1;5B"
key[Ctrl_Right]="[1;5C"
key[Ctrl_Left]="[1;5D"
key[Shift_Tab]="[Z"

bindkey -v
bindkey "${key[Home]}"          beginning-of-line
bindkey "${key[End]}"           end-of-line
bindkey "${key[Insert]}"        overwrite-mode
bindkey "${key[Delete]}"        delete-char
bindkey "${key[Backspace]}"     backward-delete-char
#bindkey "${key[Up]}"            up-line-or-history
#bindkey "${key[Down]}"          down-line-or-history
bindkey "${key[Up]}"            history-search-backward
bindkey "${key[Down]}"          history-search-forward
bindkey "${key[Left]}"          backward-char
bindkey "${key[Right]}"         forward-char
bindkey "${key[Ctrl_Left]}"     backward-word
bindkey "${key[Ctrl_Right]}"    forward-word
bindkey "${key[Shift_Tab]}"     reverse-menu-complete
bindkey "${key[PageDown]}"      end-of-buffer-or-history
bindkey "${key[PageUp]}"        beginning-of-buffer-or-history

