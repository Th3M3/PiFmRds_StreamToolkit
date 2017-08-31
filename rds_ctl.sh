#!/bin/sh

 echo >rds_ctl

while pgrep -fl "pi_fm_rds" >/dev/null;
do

# read from temp.txt and parse meta title
title=$(tail -1 temp.txt | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="StreamTitle"{print $2}' | cut -c 2- | sed 's/..$//')

# check if title has changed
if [ "$title" != "$title_old" ]; then

   # if first run, wait 3 sec before output Radio Text
   if [ -z "$title_old" ]; then sleep 3; fi

   title_old=$title

   # replace characters to RDS-Charset
   title=$(echo $title | sed 's/[ÀÂ]/A/g' | sed 's/[àâ]/a/g')
   title=$(echo $title | sed 's/[Ä]/Ae/g' | sed 's/[ä]/ae/g')
   title=$(echo $title | sed 's/[ÉÈÊË]/E/g' | sed 's/[éèêë]/e/g')
   title=$(echo $title | sed 's/[ÎÏ]/I/g' | sed 's/[îï]/i/g')
   title=$(echo $title | sed 's/[Ø]/O/g' | sed 's/[ø]/o/g')
   title=$(echo $title | sed 's/[Ö]/Oe/g' | sed 's/[ö]/oe/g')
   title=$(echo $title | sed 's/[Ü]/Ue/g' | sed 's/[ü]/ue/g')

   # write radio text (or clear if is has been removed)
   if [ -z "$title" ]; then
      echo "RT  " >>rds_ctl
   else
      echo RT "${title}" >>rds_ctl
   fi

fi
   sleep 1;
done
