#!/usr/bin/env sh

# Panel Module Generator

case $1 in
    --date-time | -d)
        date +'📅  %a, %d %b ⌚ %H : %M'
        # date +'📅  %a, %e %b ⌚ %H : %M'
        ;;
    --noti-stat | -n)
        [ -s "$DDM" ] && echo 🔕 || echo 🔔
        ;;
    --wifi | -w)
        if connected; then
            printf "🌏 %s" \
                "$(awk 'FNR == 3 { printf "%03d", $3*100/70 }' /proc/net/wireless)"
        else
            echo ❗ 000%
        fi
        ;;
    --sys-stat | -s)
        cpu="$(top -b -n 1 | awk '(NR==3){
    if( $8 == "id," )
        print "00"
    else
        printf "%02d", 100 - $8
    }')"
        mem="$(free -m | awk '(NR==2){ printf "%04d", $3 }')"
        temp="$(sensors | awk '(/Core 0/){printf $3}' | sed 's/\.0//; s/+//')"
        echo "🌡 $temp   🐎 $cpu%   🧠 $mem"
        ;;
    --vol-stat | -v)
        volstat="$(amixer get Master)"
        if echo "$volstat" | grep -o -m 1 "off" > /dev/null; then
            echo 🔇 000%
        else
            printf "🔊 %s\n" "$(echo "$volstat" | grep -o -m 1 "[0-9]\+%")"
        fi
        ;;
    --mailbox)
        printf "📫 %s" \
            find ~/.local/share/mail/gmail/INBOX/new/* -type f | wc -l
        ;;
    --bspwm | -b)
        bspc subscribe report |
            while read -r line; do
                line=${line#*:}
                line=${line%:L*}
                IFS=:
                set $line
                wm=
                while :; do
                    case $1 in
                        [FOU]*) name=🏚 ;;
                        f*) name=🕳 ;;
                        o*) name=🌴 ;;
                        *) break ;;
                    esac
                    wm="$wm $name"
                    shift
                done
                # echo "$wm"
                echo "W$wm"
            done
        ;;
    *) exit 1 ;;
esac
