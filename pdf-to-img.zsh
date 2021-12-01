#!/bin/zsh

while getopts "c:w:f:" opt; do
  case $opt in
    c) colorspace=$OPTARG ;;
    w) width=$OPTARG ;;
    f) filetype=$OPTARG ;;
    \?) echo "Invalid option: -$OPTARG" >&2 ;;
  esac
done

# checking colorspace
if [[ $colorspace == "color" ]]; then
    colorspace=''
elif [[ $colorspace == "grayscale" ]]; then
    colorspace="-colorspace Gray -background white -depth 8"
else
    echo "Invalid colorspace ${colorspace}"
fi

# checking width
if [[ ! ( $width =~ ^[0-9]+$ && $width -ge 10 && $width -le 50000 ) ]]; then
    echo "Invalid width $width"
fi

# checking filetype
if [[ ! ( $filetype == "png" || $filetype == "jpg" ) ]]; then
    echo "Invalid filetype $filetype"
fi

# checking if the input file exists, exiting if it doesn't
if [[ ! (-e "$@[-1]") ]]; then
    echo "ERROR: please include a valid pdf after the flags"
    exit 1
fi

echo "Please wait..."

# converting the file using imagemagick
cd $PWD 
zsh <<- _EOF_
convert -density 1000 "$@[-1]" $colorspace -alpha remove -alpha off -resize ${width}x${width}^ -set filename:f "%t" "%[filename:f].$filetype"
_EOF_

echo "Done!"
