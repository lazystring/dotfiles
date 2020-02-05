#!/bin/bash
# Executed for each new login shell.

# Adds ~/.local/bin to $PATH
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Window manager to use.
export LAZYWM="dwm"

# Adds `~/.scripts` and all subdirectories to $PATH
export PATH="$PATH:$HOME/.npm-global/bin/"
export BROWSER="google-chrome-stable"
export EDITOR="emacs"
export TERMINAL="st"
export FILEMGR="ranger"
export DOTFILES="$HOME/.dotfiles"

# When logging into the first tty, start X.
if [[ "$(tty)" = "/dev/tty1" ]]; then
  pgrep "$LAZYWM" || startx
fi
