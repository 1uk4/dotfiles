date_formatted=$(date "+%a %F %H:%M")
battery=$(cat /sys/class/power_supply/BAT0/capacity)% 


echo "|" $battery "|" $date_formatted 
