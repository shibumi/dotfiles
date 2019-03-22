#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#setxkbmap -layout de
# exec gnome-session
# exec startkde
#exec startxfce4
#exec awesome
# ...or the Window Manager of your choice

# setxkbmap de us
wmname LG3D
xhost +local:
image=$(ls ~/wallpapers/ | grep -E '(jpg|png)' | sort -R | tail -1)
xwallpaper --zoom "$HOME/wallpapers/$image"
exec i3
