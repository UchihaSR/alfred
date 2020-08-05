#!/bin/sh

pgrep -f "$0" | grep -v $$ &&
   doas -- ln -sf /usr/share/zoneinfo/Asia/Dhaka /etc/localtime &&
   pgrep -f "$0" | xargs kill -9

doas -- ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
while :; do
   sleep 170
   ns submit
   canberra-gtk-play -i complete
done
