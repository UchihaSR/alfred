#!/bin/sh
#
# Panel Module Generator
# Usage: panel -(b|d|m|n|s|v|w)

case $1 in
   --date-time | -d)
      date +'🕰 %H : %M  🗓  %a, %d %b'
      ;;
   --wifi | -w)
      if connected; then
         printf "🌏 %s\n" \
            "$(awk 'FNR == 3 { printf "%03d", $3*100/70 }' /proc/net/wireless)"
      else
         echo "❗ 000"
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
      echo "🧠 $mem  🐎 $cpu 🌡 $temp"
      ;;
   --vol-stat | -v)
      DUMMY_FIFO=/tmp/dff
      showstat() {
         volstat="$(amixer get Master)"
         if echo "$volstat" | grep -o -m 1 "off" > /dev/null; then
            printf "%s\r" "🔇 000"
         else
            printf "🔊 %03d\r" \
               "$(echo "$volstat" | grep -o -m 1 "[0-9]\+%" | sed 's/%//')"
         fi
      }
      trap 'showstat' RTMIN+1
      trap 'rm -f "$DUMMY_FIFO"; exit' INT TERM QUIT EXIT

      showstat
      mkfifo "$DUMMY_FIFO"
      while :; do
         : < "$DUMMY_FIFO" &
         wait
      done
      ;;
   --bspwm | -b)
      bspc subscribe report |
         while read -r line; do
            line=${line#*:}
            line=${line%:L*}
            IFS=:
            set -- $line
            wm=
            while :; do
               case $1 in
                  [FOU]*) name=🏚 ;;
                  f*) name=🕳 ;;
                  o*) name=🌴 ;;
                  *) break ;;
               esac
               if [ -z "$wm" ]; then
                  wm="$name" && shift && continue
               else
                  wm="$wm  $name"
               fi
               shift
            done
            # echo "W$wm"
            echo "$wm"
         done
      ;;
      # --mailbox | -m)
      #     printf "📫 %s" \
      #         find ~/.local/share/mail/gmail/INBOX/new/* -type f | wc -l
      # ;;
   # --noti-stat | -n)
   #     if [ -s "$DDM" ]; then echo 🔕; else echo 🔔; fi
   #     ;;
   *) exit 1 ;;
esac
