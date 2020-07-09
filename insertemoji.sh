#!/usr/bin/env sh

# Forked from Luke Smith.

cut -d ';' -f1 ~/.local/share/misc/emoji \
    | $DMENU -p "Pick an emoji" \
    | sed "s/ .*//" \
    | tr -d '\n' \
    | xsel -b && xdotool key Control+Shift+v 

# chosen=$(cat ~/.local/share/emoji | $DMENU -p "Pick an emoji" | sed "s/ .*//")
# chosen=$(cut -d ';' -f1 ~/.local/share/emoji | $DMENU -p "Pick an emoji" | sed "s/ .*//")
# [ "$chosen" ] && echo "$chosen" | tr -d '\n' | xsel -b && xdotool key Control+Shift+v
# [ "$chosen" ] && echo "$chosen" | tr -d '\n' | xclip -selection clipboard && xdotool key Control+Shift+v

