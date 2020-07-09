#!/usr/bin/env sh

# Queues up a file on mpv

MPVFIFO=/tmp/mpvfifo
mkfifo $MPVFIFO 2> /dev/null
if pidof mpv; then
    echo loadfile "$*" append-play > $MPVFIFO
else
    setsid -f mpv \
        --input-file="$MPVFIFO" \
        "$*" \
        > /dev/null 2>&1
fi

# --ontop --no-border --force-window --autofit=500x280 --geometry=-15-10 \
