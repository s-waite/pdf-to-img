#!/bin/zsh

WHITE_FG=$( tput setaf 0 )
RED_FG=$( tput setaf 1 )
GREEN_FG=$( tput setaf 2 )
YELLOW_FG=$( tput setaf 3 )
BLUE_FG=$( tput setaf 4 )
MAGENTA_FG=$( tput setaf 5 )
CYAN_FG=$( tput setaf 6 )
WHITE_FG=$( tput setaf 7 )
RESET=$( tput sgr0 )




if [[ ! (-e "$1") ]]; then
    echo "ERROR: please include a valid pdf as the first argument"
    exit 1
fi

reset_cursor () {
    tput cup 0 0
}

clear_screen () {
    reset_cursor
    tput ed || tput cd
}

clear_screen

while true; do
    reset_cursor
    echo "${BLUE_FG}Select your output format:${RESET}

    ${RED_FG}1.${RESET} PNG
    ${RED_FG}2.${RESET} JPG
"

    read "SELECTION?${GREEN_FG}Input: ${RESET}"

    if [[ $SELECTION == 1 ]]; then
        FILETYPE="png"
        break
    elif [[ $SELECTION == 2 ]]; then
        FILETYPE="jpg"
        break
    else
        echo "Please enter a valid selection"
    fi
done

clear_screen

while true; do
    reset_cursor
    echo "Input your desired width in pixels
    "
    read "WIDTH?Input: "
    if [[ $WIDTH =~ ^[0-9]+$ && $WIDTH -ge 10 && $WIDTH -le 50000 ]]; then
        break
    else
        echo "Please enter a valid number"
    fi
done

clear_screen

while true; do
    reset_cursor
    echo "Colorspace

    1. Grayscale
    2. Color
    "
    read "SELECTION?Input: "
    if [[ $SELECTION == 1 ]]; then
        COLORSPACE="-colorspace Gray -background white -depth 8"
        break
    elif [[ $SELECTION == 2 ]]; then
        COLORSPACE=''
        break
    else
        echo "Please enter a valid number"
    fi
done

echo "Please wait..."
zsh <<- _EOF_
convert -density 1000 $1 $COLORSPACE -alpha remove -alpha off -resize ${WIDTH}x${WIDTH}^ -set filename:f "%t" "%[filename:f].$FILETYPE"
_EOF_