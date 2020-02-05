#!/bin/sh

[ -f ~/.xprofile] && . ~/.xprofile
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

case "$LAZYWM" in
  dwm)
    while :; do
      ssh-agent dwm || break
    done ;;
  i3)
    exec i3 ;;
  *) echo "No valid window manager configured" ;;
esac
