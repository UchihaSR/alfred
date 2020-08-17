#!/bin/sh
#
# Video editing scripts

case $1 in
    --add-audio | -aa)
        shift
        ffmpeg \
            -i "$1" \
            -stream_loop -1 -i "$2" \
            -filter_complex "[0:a][1:a]amerge=inputs=2[a]" \
            -map 0:v -map "[a]" \
            -c:v copy -c:a mp3 \
            -shortest -y \
            "${1%.*}"-"$(date +'%Y%b%d-%H%M%S')"."${1##*.}"
        # -c:a aac -strict experimental -b:a 192k -ac 2 \
        ;;
    --change-volume | -cv)
        shift
        echo "Volume level? ( 00 to 99)"
        read -r level
        ffmpeg \
            -i "$1" \
            -af "volume=0.$level" \
            -y \
            "${1%.*}"-"$(date +'%Y%b%d-%H%M%S')"."${1##*.}"
        ;;
    --make-gif | -mg)
        shift
        PALETTE="/tmp/palette.png"
        FILTERS="fps=5,scale=720:-1:flags=lanczos"
        ffmpeg -i "$1" -vf "$FILTERS,palettegen" -y $PALETTE
        ffmpeg \
            -i "$1" -i $PALETTE -y \
            -lavfi "$FILTERS [x]; [x][1:v] paletteuse" \
            "${1%.*}"-"$(date +'%Y%b%d-%H%M%S')".gif
        rm -f $PALETTE
        ;;
    --cut | -c)
        shift
        echo "Starting Point? (ex. 00:00)"
        read -r start
        echo "Endin Point? (ex. 00:05)"
        read -r end
        ffmpeg -y -i "$1" -ss "00:$start" -to "00:$end" \
            "${1%.*}"-"$(date +'%Y%b%d-%H%M%S')"."${1##*.}"
        ;;
    --join | -j)
        for vid in "$PWD"/*.mkv; do
            echo "file '$vid'" >> list
            ffmpeg -f concat -i list -c copy -y all.mkv
            rm list
        done
        ;;
esac
