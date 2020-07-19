#!/bin/sh

# content="$(tmux capture-pane -J -p)"
# urls=($(echo "$content" |grep -oE '(https?|ftp|file):/?//[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]'))
# wwws=($(echo "$content" |grep -oE 'www\.[a-zA-Z](-?[a-zA-Z0-9])+\.[a-zA-Z]{2,}(/\S+)*'                  |sed 's/^\(.*\)$/http:\/\/\1/'))
# ips=($(echo  "$content" |grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(:[0-9]{1,5})?(/\S+)*' |sed 's/^\(.*\)$/http:\/\/\1/'))
# gits=($(echo "$content" |grep -oE '(ssh://)?git@\S*' | sed 's/:/\//g' | sed 's/^\(ssh\/\/\/\)\{0,1\}git@\(.*\)$/https:\/\/\2/'))

# merge() {
#     for item in "$@"; do
#         echo "$item"
#     done
# }

# merge "${urls[@]}" "${wwws[@]}" "${ips[@]}" "${gits[@]}"|
#     sort -u |
#     nl -w3 -s '  ' |
#     fzf_cmd |
#     awk '{print $2}'|
#     xargs -n1 -I {} launch --link {} &>/dev/null ||
#     true

# while IFS= read -r line; do
#     echo "$line"
# done

SHOWCURSOR="\033[?25h"
HIDECURSOR="\033[?25l"
ENABLEWRAP="\033[?7h"
DISABLEWRAP="\033[?7l"
CLEAR="\033[2J\033[H"

urls=$(grep -oE '(https?|ftp|file):/?//[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' "$1")
cursor=1
items=$(echo "$urls" | wc -l)

mark() {
    printf "\033[7m"
    echo "$@"
    printf "\033[27m"
}

goto() { printf "%b" "\033[${1};${2}H"; }

header() {
    goto 1 "$((COLUMNS / 2 - 10))"
    mark "$@"
    printf "\n\n\n"
}

footer() {
    goto "$((LINES - 1))" "$((COLUMNS / 2 - 10))"
    mark "$@"
}

mark() {
    printf "\033[7m"
    echo "$@"
    printf "\033[27m"
}

handleinput() {
    case $1 in
        ';') ns launch ;;
        l) [ "$cursor" -lt "$items" ] && cursor=$((cursor + 1)) ;;
        k) [ "$cursor" -gt 1 ] && cursor=$((cursor - 1)) ;;
    esac
}

getkey() {
    stty -icanon -echo
    dd bs=1 count=1 2> /dev/null
    stty icanon echo
}

showui() {
    goto 3 0
    i=0
    for url in $urls; do
        i=$((i + 1))
        if [ "$i" = "$cursor" ]; then
            mark "$url"
        else
            echo "$url"
        fi
    done
}

setscreen() {
    printf "%b" "$DISABLEWRAP$HIDECURSOR$CLEAR"
    LINES=$(stty size | cut -d' ' -f1)
    COLUMNS=$(stty size | cut -d' ' -f2)
}

setscreen
header url picker
footer l:Down k:Up n:Quit
while :; do
    showui
    handleinput "$(getkey)"
done
