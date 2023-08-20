#!/bin/sh


swayidle \ 
    timeout 10 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on "' &

swaylock --clock -c 550000

kill %%



