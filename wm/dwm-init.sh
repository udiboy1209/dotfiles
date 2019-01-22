#!/bin/bash

echo "Setting background and starting mpd, slstatus"
time /home/udiboy/.fehbg
time mpd /home/udiboy/.config/mpd/mpd.conf
slstatus &

echo "Backlight, compton redshift"
xbacklight -set 30
compton &
redshift -l "19.076:72.877" &

echo "Other settings"
amixer set Master 60% on
amixer set Headphone 100% on
amixer set Speaker 100% off

xmodmap -e "keycode 109="

