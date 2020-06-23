#!/usr/bin/env sh

# Checks if internet is available or not

grep "up" /sys/class/net/w*/operstate > /dev/null &&
   wget -q --spider http://google.com

# ping -q -c 1 1.1.1.1 > /dev/null 2>&1 \
# || notify-send -t 3000 -i "$ICONS"/disconnected.png "Disconnected"
