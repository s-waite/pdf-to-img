#!/bin/zsh

# colors to use in the program
WHITE_FG=$( tput setaf 0 )
RED_FG=$( tput setaf 1 )
GREEN_FG=$( tput setaf 2 )
YELLOW_FG=$( tput setaf 3 )
BLUE_FG=$( tput setaf 4 )
MAGENTA_FG=$( tput setaf 5 )
CYAN_FG=$( tput setaf 6 )
WHITE_FG=$( tput setaf 7 )
RESET=$( tput sgr0 )

PROMPT_FG=$BLUE_FG
NUMBER_FG=$RED_FG

# checking if the input file exists, exiting if it doesn't
if [[ ! (-e "$1") ]]; then
    echo "ERROR: please include a valid pdf as the first argument"
    exit 1
fi

# moving terminal cursor to top left corner
reset_cursor () {
    tput cup 0 0
}

# clearing terminal screen
clear_screen () {
    reset_cursor
    tput ed || tput cd
}

# input function to use in the menus
get_input () {
    read "SELECTION?${GREEN_FG}Input: ${RESET}"
}

clear_screen

# loop where user selects the output format
while true; do
    reset_cursor
    echo "${PROMPT_FG}Select your output format:${RESET}

    ${NUMBER_FG}1.${RESET} PNG
    ${NUMBER_FG}2.${RESET} JPG
"
    get_input

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

# loop where user selects the output image size
while true; do
    reset_cursor
    echo "${PROMPT_FG}Input your desired width in pixels${RESET}
    "
    get_input
    # get_input assigns the result to SELECTION
    WIDTH=$SELECTION

    # ensuring the user entered a valid value
    if [[ $WIDTH =~ ^[0-9]+$ && $WIDTH -ge 10 && $WIDTH -le 50000 ]]; then
        break
    else
        echo "Please enter a valid number"
    fi
done

clear_screen

# loop where user selects colorspace for output
while true; do
    reset_cursor
    echo "Colorspace

    1. Grayscale
    2. Color
    "
    get_input
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

# using imagemagick to convert the pdf using the user supplied values
zsh <<- _EOF_
convert -density 1000 $1 $COLORSPACE -alpha remove -alpha off -resize ${WIDTH}x${WIDTH}^ -set filename:f "%t" "%[filename:f].$FILETYPE"
_EOF_
