#!/bin/zsh

source $ZDOTDIR/theme.sh

#SEPARATOR_CHAR='»'
SEPARATOR_CHAR=''
GIT_BRANCH_CHAR=''
GIT_TAG_CHAR=''
GIT_DIFF_CHAR="~"
PYTHON_CHAR=''

export VIRTUAL_ENV_DISABLE_PROMPT=1

function git_prompt_block() {
    if [[ $(git status 2>/dev/null; echo $?) == 128 ]]; then
        echo -en ""
        exit
    fi

    local BRANCH=$(git status --branch 2>/dev/null | head -n 1 | awk '{print $NF}')
    if [ ! -z "$BRANCH" ]; then BRANCH="${GIT_BRANCH_CHAR} ${BRANCH}"; else BRANCH=""; fi

    local TAG=$(git tag --points-at 2>/dev/null)
    if [ ! -z "$TAG" ]; then TAG=" (${GIT_TAG_CHAR} ${TAG})"; else TAG=""; fi

    local CHANGES=
    if [ "$(git status --short 2>/dev/null)" ]; then 
        CHANGES=" (${GIT_DIFF_CHAR})"; else CHANGES=""
    fi

    echo -en "${BRANCH}${TAG}%{$fg_bold[${ERROR_COLOR_NAME}]%}${CHANGES}%{$fg[${WARNING_COLOR_NAME}]%} ${SEPARATOR_CHAR} "
}

function venv_prompt_block() {
    if [[ "$VIRTUAL_ENV" ]]; then
        echo -en "${PYTHON_CHAR} $(basename ${VIRTUAL_ENV}) ($(python --version | awk '{print $NF}')) ${SEPARATOR_CHAR} "
    fi
}

setopt prompt_subst
export PROMPT='%{$fg[${ACCENT_COLOR_NAME}]%}%n ${SEPARATOR_CHAR} %~ ${SEPARATOR_CHAR} %{$fg[${WARNING_COLOR_NAME}]%}$(venv_prompt_block)$(git_prompt_block)%{$reset_color%}'

