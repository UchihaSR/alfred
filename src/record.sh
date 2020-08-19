#!/bin/sh
#
# General purpose recording script

RESOLUTION=$(xrandr | awk '(/current/){print $8 "x" $10 }' | sed 's/,//')

case $1 in
   --display | -d)
      # Forked from https://github.com/dylanaraps
      scr_dir=~
      date=$(date +%F)
      time=$(date +%I-%M-%S)
      file=$scr_dir/$date/$date-$time.png
      mkdir -p "$scr_dir/$date"
      ffmpeg -y \
         -hide_banner \
         -loglevel error \
         -f x11grab \
         -video_size "$RESOLUTION" \
         -i "$DISPLAY" \
         -vframes 1 \
         "$file"
      cp -f "$file" "$scr_dir/current.png"
      ;;
esac

# -i :0.0 \
