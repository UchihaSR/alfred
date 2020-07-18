#!/usr/bin/env sh
#
# Modulates backlight levels
# Usage: backlight --(up|down)

for device in /sys/class/backlight/*; do
    read -r CURRENT < "$device"/brightness
    read -r MAX < "$device"/max_brightness
    MARGIN=$((MAX / 10))
    case $1 in
        --up)
            [ "$CURRENT" = "$MAX" ] && exit
            increased=$((CURRENT + MARGIN))
            [ "$increased" -gt "$MAX" ] && increased="$MAX"
            echo "$increased" > "$device"/brightness
            ;;
        --down)
            echo $((CURRENT - MARGIN)) > "$device"/brightness
            ;;
    esac
done
