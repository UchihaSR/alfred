#!/usr/bin/env sh
#
# Modulates backlight levels
# Usage: backlight --(up|down)

# DEVICE=$(echo /sys/class/backlight/*)

direction=${1:?}
set -- /sys/class/backlight/*
DEVICE=$1

read -r CURRENT < "$DEVICE"/brightness
read -r MAX < "$DEVICE"/max_brightness
MARGIN=$((MAX / 10))

case $1 in
    --up)
        increased=$((CURRENT + MARGIN))
        [ "$increased" -gt "$MAX" ] && increased="$MAX"
        echo "$increased" > "$DEVICE"/brightness
        ;;
    --down)

        echo $((CURRENT - MARGIN)) > "$DEVICE"/brightness
        ;;
    *) exit 1 ;;
esac
