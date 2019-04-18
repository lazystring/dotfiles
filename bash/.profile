#!/bin/bash
# Executed for each new login shell.

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Adds `~/.scripts` and all subdirectories to $PATH
export PATH="$PATH:$(du "$HOME/.scripts/" | cut -f2 | tr '\n' ':')"
export PATH="$PATH:$HOME/.npm-global/bin/"
export BROWSER="google-chrome-stable"
export EDITOR="emacs"
export TERMINAL="st"
export FILEMGR="ranger"
export DOTFILES="$HOME/.dotfiles"

# When logging into the first tty, start X.
if [[ "$(tty)" = "/dev/tty1" ]]; then
  pgrep i3 || startx
fi
