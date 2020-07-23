#!/usr/bin/env sh
#
# General purpose launching script

run() { "$@" > /dev/null 2>&1 & }

case $1 in
    --bookmarker | -b)
        # xdotool key Control+l && sleep 1 && exit
        # xdotool keyup j key --clearmodifiers Control+l && sleep 1 && exit
        # xte 'keydown Control_L' 'keydown l' 'keyup Control_L' 'keyup l' && exit
        # xte 'keydown Super_L' 'keydown t' 'keyup Super_L' 'keyup t' && exit
        # xte 'keydown Super_L' 'keydown t' && sleep 0.2 && xte 'keyup Super_L' 'keyup t' && exit
        # xte 'keydown Ctrl_L' 'keydown l' && sleep 0.2 && xte 'keyup Ctrl_L' 'keyup l' && exit
        BOOKMARKS=/mnt/horcrux/git/own/private/.local/share/bookmarks
        LOCATION=$(find $BOOKMARKS -type d |
            awk -F / '{print $NF}' |
            $DMENU -p 'Bookamark location') &&
            TITLE=$($DMENU -p 'Bookamrk title') &&
            LINK=$($DMENU -p 'Bookamrk link') &&
            echo "$LINK" > "$(find $BOOKMARKS -type d -name "$LOCATION")"/"$TITLE".link
        ;;
    --choose | -c)
        shift
        choice=$(printf "📚 Okular\n📖 Foxit Reader\n📙 Master PDF Editor\n💻 Code\n🎥 MPV\n🌏 Browser" |
            rofi -dmenu -i -p "Open with" | sed "s/\W//g") &&
            case "$choice" in
                Browser) $BROWSER --new-window "$*" ;;
                Okular) okular "$*" ;;
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
                run firefox "$1"
                # setsid -f firefox "$1" > /dev/null 2>&1
                ;;
        esac
        ;;
    --tmux | -t)
        if ! pidof tmux; then
            tmux new-session -d -n 'news&mail' 'newsboat' \; \
                split-window -h 'neomutt' \; \
                swap-pane -d -t :.1 \; \
                select-layout main-vertical
            "$TERMINAL" -e tmux attach &
        fi
        ;;
    --explorer | -e)
        launch --tmux 2> /dev/null # Personal Script
        if pidof tmux; then
            tmux new-window
        else
            tmux new-session -d \; switch-client
        fi
        if pidof "$TERMINAL"; then
            [ "$(pidof "$TERMINAL")" != "$(xdo pid)" ] &&
                xdo activate -N Alacritty
        else
            "$TERMINAL" -e tmux attach &
        fi
        tmux send "explore $2" "Enter"
        ;;
    --terminal | -T)
        $0 -t
        if pidof tmux; then
            tmux new-window
        else
            tmux new-session -d \; switch-client
        fi
        if pidof "$TERMINAL"; then
            [ "$(pidof "$TERMINAL")" != "$(xdo pid)" ] &&
                xdo activate -N Alacritty
        else
            "$TERMINAL" -e tmux attach &
            # "$TERMINAL"
            # sleep 0.5
            # xdo key_press -k 28
            # xdo key_release -k 28
            # xdo key_press -k 38
            # sleep 0.2
            # xdo key_release -k 38
            # xdo key_press -k 36
            # sleep 0.2
            # xdo key_release -k 36
        fi

        ;;
    *)
        case $1 in
            *.ar.*)
                alacritty \
                    --config-file ~/.config/alacritty/alacritty_ar.yml \
                    -e "$EDITOR" "$*" &
                exit
                ;;
            *.link)
                $BROWSER "$(cat "$*")"
                exit
                ;;
            *.sent)
                sent "$*" &
                exit
                ;;
        esac
        case $(file --mime-type "$*" -bL) in
            text/* | inode/x-empty | application/json | application/octet-stream)
                $EDITOR "$*"
                ;;
            inode/directory)
                explore "$*"
                ;;
            video/* | audio/* | image/gif)
                qmedia "$1"
                # testt mpv "$*"
                ;;
            application/pdf | application/postscript | application/epub+zip | image/vnd.djvu)
                devour zathura -- "$*"
                ;;
            image/*)
                devour feh -A 'setdisplay --bg %f' -B 'black' \
                    -d --edit --keep-zoom-vp --start-at \
                    -- "$*"
                ;;
            application/*)
                extract --clean "$*"
                ;;
        esac
        ;;
esac
