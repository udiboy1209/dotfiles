#!/bin/bash

echo "Set background and backlight, start slstatus"
date +'%s %N'
/home/udiboy/.fehbg
slstatus &
xbacklight -set 30


echo "Start compton, redshift and mpd"
date +'%s %N'
pgrep compton || compton &
pgrep redshift || redshift -l "19.076:72.877" &
mpd /home/udiboy/.config/mpd/mpd.conf

echo "Other settings"
date +'%s %N'
pamixer --set-volume 60
xmodmap -e "keycode 109="



