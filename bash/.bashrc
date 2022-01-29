#!/bin/bash

# Executed for each new non-login shell.
#  _               _
# | |__   __ _ ___| |__  _ __ ___
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__
# |_.__/ \__,_|___/_| |_|_|  \___|

# Disable Ctrl+S and Ctrl+Q.
stty -ixon

# Allows you to 'cd' into a directory merely by typing the directory name.
shopt -s autocd

# Append to history file.
shopt -s histappend

# Infinite history size.
HISTSIZE= HISTFILESIZE=

# Bash prompt.
BOLD="\[$(tput bold)\]"
RED="\[$(tput setaf 1)\]"
YELLOW="\[$(tput setaf 3)\]"
GREEN="\[$(tput setaf 2)\]"
BLUE="\[$(tput setaf 4)\]"
MAGENTA="\[$(tput setaf 5)\]"
WHITE="\[$(tput setaf 7)\]"
RESET="\[$(tput sgr0)\]"

export PS1="${BOLD}${RED}[${YELLOW}\u${GREEN}@${BLUE}\h ${MAGENTA}\W${RED}]${WHITE}\$ ${RESET}"

# Run other bash commands.
[ -f "$HOME/.aliasrc" ] && source "$HOME/.aliasrc"

# virtualenvwrapper initialization.
source ~/.local/bin/virtualenvwrapper.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
