#!/usr/bin/env sh
#
# Modulates backlight level

DEVICE=/sys/class/backlight/"$(ls /sys/class/backlight)"
CURRENT="$(cat "$DEVICE"/brightness)"
MAX="$(cat "$DEVICE"/max_brightness)"
MARGIN="$((MAX * 10 / 100))"

case $1 in
    --up)
        increased="$((CURRENT + MARGIN))"
        [ "$increased" -gt "$MAX" ] && increased="$MAX"
        echo "$increased" > "$DEVICE"/brightness
        ;;
    --down)
        DECREASED="$((CURRENT - MARGIN))"
        echo "$DECREASED" > "$DEVICE"/brightness
        ;;
esac
