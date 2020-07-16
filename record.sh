#!/usr/bin/env sh

RESOLUTION=$(xrandr | awk '(/current/){print $8 "x" $10 }' | sed 's/,//')

case $1 in
    --screen | -s)
        # Stolen from https://github.com/dylanaraps
        scr_dir=~
        date=$(date +%F)
        time=$(date +%I-%M-%S)
        file=$scr_dir/$date/$date-$time.png
        mkdir -p "$scr_dir/$date"
        ffmpeg -y \
            -hide_banner \
            -loglevel error \
            -f x11grab \
            -video_size 1366x768 \
            -i :0.0 \
            -vframes 1 \
            "$file"
        cp -f "$file" "$scr_dir/current.png"
        ;;
esac
