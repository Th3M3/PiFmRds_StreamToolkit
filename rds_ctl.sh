#!/bin/sh

 echo > /home/pi/rds_ctl

while pgrep -fl "pi_fm_rds" >/dev/null;
do

title=$(awk 'NR==1; END{print}' /home/pi/temp.txt | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="StreamTitle"{print $2}' | cut -c 2- | sed 's/..$//')


if [ "$title" != "$title_old" ]; then

   title_old=$title
   echo RT $title >>/home/pi/rds_ctl
fi
   sleep 1;
done
