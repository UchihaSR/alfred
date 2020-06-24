#!/usr/bin/env sh

if [ "$1" = --devour ]; then
    shift
    if echo "$*" | grep "\.ar\."; then
        devour alacritty \
            --config-file ~/.config/alacritty/alacritty_ar.yml \
            -e "$EDITOR" "$*" &
        exit
    elif echo "$*" | grep "\.sent$"; then
        devour sent "$1" &
        exit
    fi
else
    choice=$(printf "📖 Foxit Reader\n📚 Master PDF Editor\n💻 Code" |
        rofi -dmenu -i -p "Open with" | sed "s/\W//g")
    [ ! "$choice" ] && exit
    case "$choice" in
        FoxitReader) swallow foxitreader "$1" ;;
        MasterPDFEditor) swallow masterpdfeditor4 "$1" ;;
        Code) swallow code "$1" ;;
    esac && exit
fi

case $(file --mime-type "$*" -bL) in
    text/* | inode/x-empty | application/json | application/octet-stream)
        "$EDITOR" "$*"
        ;;
    video/*)
        pidof mpv || devour mpv "$*"
        ;;
    application/pdf | application/postscript)
        devour zathura "$*"
        ;;
    image/gif)
        pgrep mpv || devour "mpv --loop" "$*"
        ;;
    image/*)
        pidof feh ||
            devour \
                "feh -A 'alfred --bg %f' -B 'black' -F -d --edit --keep-zoom-vp --start-at" "$*"
        ;;
    application/zip)
        unzip "$*" -d "${1%.*}"
        ;;
esac
