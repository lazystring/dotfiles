#!/bin/bash
# Executed for each new login shell.

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Adds `~/.scripts` and all subdirectories to $PATH
export PATH="$PATH:$(du "$HOME/.scripts/" | cut -f2 | tr '\n' ':')"
export BROWSER="google-chrome-stable"
export EDITOR="emacs"
export TERMINAL="st"
export FILEMGR="ranger"
export DOTFILES="$HOME/.dotfiles"
