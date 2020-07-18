#!/usr/bin/env sh
#
# Modulates backlight levels
# Usage: backlight --(up|down)

ARG=${1:?}
set -- /sys/class/backlight/*
DEVICE=$1
set -- "$ARG"

read -r CURRENT < "$DEVICE"/brightness
read -r MAX < "$DEVICE"/max_brightness
MARGIN=$((MAX / 10))

case $1 in
    --up)
        [ "$CURRENT" = "$MAX" ] && exit
        increased=$((CURRENT + MARGIN))
        [ "$increased" -gt "$MAX" ] && increased="$MAX"
        echo "$increased" > "$DEVICE"/brightness
        ;;
    --down)
        echo $((CURRENT - MARGIN)) > "$DEVICE"/brightness
        ;;
esac
