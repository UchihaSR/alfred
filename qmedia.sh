#!/usr/bin/env sh

MPVFIFO=/tmp/mpvfifo
mkfifo $MPVFIFO
if pidof mpv; then
    echo loadfile "$1" append-play > $MPVFIFO
else
    setsid -f mpv --input-file="$MPVFIFO" "$1" > /dev/null 2>&1
fi
