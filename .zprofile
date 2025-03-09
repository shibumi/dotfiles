PATH=$PATH:$HOME/.local/bin/
PATH=$PATH:$HOME/go/bin/
PATH="${PATH}:${HOME}/.krew/bin"

dbus-update-activation-environment --systemd \
  DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Added by Toolbox App
export PATH="$PATH:/home/chris/.local/share/JetBrains/Toolbox/scripts"

