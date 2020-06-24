#!/usr/bin/env sh

# XDG Killer
# Launches files based on their mimetype
# If you are overwhelmed by all this gibberish,
#   just ignore the sections before the case statement

echo "$*" | grep "\.ar\." && {
    devour alacritty \
        --config-file ~/.config/alacritty/alacritty_ar.yml \
        -e "$EDITOR" "$*" &
    exit
}
echo "$1" | grep "\.sent$" && {
    devour sent "$1" &
    exit
}
case $(file --mime-type "$*" -bL) in
    # Check for the mimetype of your file
    text/* | inode/x-empty | application/json | application/octet-stream)
        # Launch using your favorite application
        "$EDITOR" "$*"
        ;;
    video/*)
        pidof mpv || devour mpv "$*"
        ;;
    application/pdf | application/postscript)
        pidof zathura || devour zathura "$*"
        ;;
    image/gif)
        pgrep mpv || devour "mpv --loop" "$*"
        ;;
    image/*)
        pidof feh ||
            devour \
                "feh -A 'set-bg %f' -B 'black' -F -d --edit --keep-zoom-vp --start-at" "$*"
        ;;
    application/zip)
        unzip "$*" -d "${1%.*}"
        ;;
esac
