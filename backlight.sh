#!/usr/bin/env sh
#
# Modulates backlight levels
# Usage: backlight --(up|down)

DEVICE=$(echo /sys/class/backlight/*)
CURRENT=$(cat "$DEVICE"/brightness)
MAX=$(cat "$DEVICE"/max_brightness)
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
