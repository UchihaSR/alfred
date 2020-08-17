#!/bin/sh
#
# General purpose launching script

run() { setsid "$@" > /dev/null 2>&1 & }

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
      choice=$(printf "📕 Zathura\n📘 Evince\n📖 Foxit Reader\n📙 Master PDF Editor\n💻 Code\n🎥 MPV\n🌏 Browser" |
         rofi -dmenu -i -p "Open with" | sed "s/\W//g") &&
         case "$choice" in
            Zathura) run zathura "$1" ;;
            Evince) run evince "$1" ;;
            Browser) run $BROWSER --new-window "$1" ;;
            FoxitReader) run foxitreader "$1" ;;
            MasterPDFEditor) run masterpdfeditor4 "$1" ;;
            Code) run code "$1" ;;
            MPV) run mpv --shuffle "$1" ;;
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
            ;;
      esac
      ;;
   --tmux | -t)
      pidof tmux || {
         tmux new-session -d -n 'news&mail' 'neomutt' \; \
            split-window -h 'calcurse' \; \
            split-window 'newsboat' \; \
            split-window 'weechat' \; \
            select-pane -t :.1
      }
      pidof "$TERMINAL" || "$TERMINAL" -e tmux attach &
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
            devour sent "$*" &
            sleep 2
            bspc node -t fullscreen
            exit
            ;;
      esac

      case $(file --mime-type "$1" -bL) in
         text* | *x-empty | *json | *octet-stream)
            $EDITOR "$1"
            ;;
         *directory)
            explore "$1"
            ;;
         video* | audio* | *gif)
            qmedia "$1"
            # testt mpv "$*"
            ;;
         *pdf | *postscript | *epub+zip | *vnd.djvu)
            devour zathura -- $*
            # devour zathura -- $*
            ;;
         image*)
            devour feh -A "setdisplay --bg %f" -B 'black' \
               -d --edit --keep-zoom-vp --start-at \
               -- $*
            ;;
         *x-bittorrent)
            torrent --add "$1"
            ;;
         *.document)
            pandoc "$1" -o "${1%.*}.pdf"
            devour zathura -- ${1%.*}.pdf
            ;;
         application*)
            extract --clean "$1"
            ;;
      esac
      ;;
esac
