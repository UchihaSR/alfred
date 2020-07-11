#!/usr/bin/env sh

# Audio player controller for spotify & mpd
# setplayer --[next,prev,toggle]

setplayer() { playerctl "$1" || mpc "$1"; }
pidof mpd || mpd
case $1 in
    next) setplayer next ;;
    prev) setplayer prev ;;
    toggle) setplayer play-pause || setplayer toggle ;;
    vol)
        case $2 in
            up) pactl set-sink-volume @DEFAULT_SINK@ +10% ;;
            down) pactl set-sink-volume @DEFAULT_SINK@ -10% ;;
            mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
        esac
        canberra-gtk-play -i audio-volume-change
        uniblocks -r v
        ;;
    *) : ;;
esac
