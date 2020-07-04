#!/usr/bin/env sh

# All purpose launch script

case $1 in
    --choose | -c)
        shift
        choice=$(printf "📖 Foxit Reader\n📚 Master PDF Editor\n💻 Code\n🎥 MPV" |
            rofi -dmenu -i -p "Open with" | sed "s/\W//g")
        [ ! "$choice" ] && exit
        case "$choice" in
            FoxitReader) foxitreader "$*" ;;
            MasterPDFEditor) masterpdfeditor4 "$*" ;;
            Code) code "$*" ;;
            MPV) mpv --shuffle "$*" ;;
        esac
        ;;
    --link | -l)
        shift
        case "$1" in
            *mkv | *webm | *mp4 | *mp3 | *youtube.com/watch* | *youtube.com/playlist* | *youtu.be*)
                qmedia "$1"
                ;;
            *)
                setsid -f firefox "$1" > /dev/null 2>&1
                ;;
        esac
        ;;
    --tmux | -t)
        [ "$(tmux ls)" ] || tmux new-session -d
        if pidof "$TERMINAL"; then
            xdo activate -N Alacritty
            tmux new-window
        else
            "$TERMINAL" -e tmux attach
        fi
        ;;
    *)
        if echo "$*" | grep "\.ar\."; then
            alacritty \
                --config-file ~/.config/alacritty/alacritty_ar.yml \
                -e "$EDITOR" "$*" &
            exit
        elif echo "$*" | grep "\.sent$"; then
            sent "$*" &
            exit
        fi
        case $(file --mime-type "$*" -bL) in
            text/* | inode/x-empty | application/json | application/octet-stream)
                $EDITOR "$*"
                ;;
            video/* | audio/* | image/gif)
                qmedia "$*"
                ;;
            application/pdf | application/postscript)
                pidof zathura || devour zathura "$*"
                ;;
            image/*)
                pidof feh ||
                    feh -A 'setdisplay --bg %f' -B 'black' -F -d --edit --keep-zoom-vp --start-at "$*"
                ;;
            application/*)
                extract --clean "$*"
                ;;
        esac
        ;;
esac
