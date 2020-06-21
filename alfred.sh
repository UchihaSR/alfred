#!/usr/bin/env sh

setbg() {
    wall=/tmp/wall
    setpic() { feh --no-fehbg --bg-scale "$1"; }
    if [ "$1" = shuffle ]; then
        find "$WALLPAPERS" -name "*.jpg" -o -name "*.png" | shuf -n1 | tee "$wall"
    elif [ "$1" = delete ]; then
        find "$WALLPAPERS" -name "$(cat $wall)" -delete
        setbg shuffle
        return
    else
        echo "$1" > $wall
    fi
    setpic "$(cat $wall)"
}

setdpi() {
    file=~/.config/X11/Xresources

    grep 'Xft.dpi' "$file" && xrdb -merge "$file" && return

    info=$(xrandr | grep ' connected')

    width=$(echo "$info" | awk '{print $NF}')
    width_in=$(echo "${width%mm}" | awk '{print $1 * 0.03937007874015748}')

    height=$(echo "$info" | awk '{print $(NF-2)}')
    height_in=$(echo "${height%mm}" | awk '{print $1 * 0.03937007874015748}')

    diagonal_in=$(awk -v w="$width_in" -v h="$height_in" \
        'BEGIN{print sqrt(w^2 + h^2)}')

    px=$(echo "$info" | cut -d ' ' -f 4)

    width_px=${px%x*}

    height_px=${px#*x}
    height_px=${height_px%%+*}

    diagonal_px=$(awk -v w="$width_px" -v h="$height_px" \
        'BEGIN{print sqrt(w^2 +h^2)}')

    dpi=$(awk -v dp="$diagonal_px" -v di="$diagonal_in" \
        'BEGIN{print dp / di}')

    echo "Xft.dpi: $dpi" >> "$file"
    xrdb -merge "$file"
}

while :; do
    case $1 in
        --background)
            notify-send "here"
            shift
            setbg "$1"
            ;;
        --dpi) setdpi ;;
        *) break ;;
    esac
    shift
done
