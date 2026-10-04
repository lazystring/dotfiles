#!/bin/sh

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
[ -f ~/.xprofile ] && . ~/.xprofile
[ -f ~/.Xmodmap  ] && xmodmap ~/.Xmodmap

systemctl --user import-environment DISPLAY

case "$LAZYWM" in
  dwm)
    while :; do
      ssh-agent dwm || break
    done ;;
  i3)
    exec i3 ;;
  xmonad)
    exec xmonad ;;
  *) echo "No valid window manager configured" ;;
esac

# Prevents having multiple ssh-agent processes running at the same time.
pkill ssh-agent
eval $(ssh-agent -s)
