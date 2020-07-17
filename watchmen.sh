#!/usr/bin/env sh
#
# Monitors specific directores for particular changes and runs commands

# dirs=
# dirs="$dirs $GIT/own/magpie"
# dirs="$dirs $GIT/own/private"

dirs="
$GIT/own/magpie
$GIT/own/private"

# dirs="$GIT/own/magpie $GIT/own/private"

inotifywait -m -r -e create,moved_to $dirs |
    while read -r line; do
        cp -frsu -t ~ \
            "$GIT"/own/magpie/. \
            "$GIT"/own/private/.
    done &

# path=~/.local/share/mail/gmail/INBOX/new
# inotifywait -m -e move $path |
#     while read -r line; do
#         refresh-block 2
#     done &
