#!/bin/sh

tim=/tmp/blurred.png

echo "Blurring $1 -> $3"
#convert $1 -blur 0x16 -spread 24 $tim
#echo "Adding logo $2 to $tim -> $3"
#convert $tim $2 -gravity center -shadow 75x3+0+0 -composite $3

convert \( $1 -blur 0x16 -spread 24 \) \
        \( $2 -resize 182x182 \) \
        \( +clone -background black -shadow 65x5+0+0 \) \
        \( -clone 2 -clone 1 -background None -layers merge +repage \) \
        -delete 1,2 -gravity center -compose over -composite $3
