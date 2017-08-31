#!/bin/sh

# read from DataPipe and parse meta data
while read line;
do
   # catch Station Name
   if [ "$(echo "$line" | cut -c 1-9)" = 'ICY-NAME:' ];
   then
      station=$line
   fi

   # catch Stream current Title
   if [ "$(echo "$line" | cut -c 1-9)" = 'ICY-META:' ];
   then
      # parse meta data from line
      title=$(echo $line | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="StreamTitle"{print $2}' | cut -c 2- | sed 's/..$//')

      # replace characters to RDS-Charset
      title=$(echo $title | sed 's/[ÀÂ]/A/g' | sed 's/[àâ]/a/g')
      title=$(echo $title | sed 's/[Ä]/Ae/g' | sed 's/[ä]/ae/g')
      title=$(echo $title | sed 's/[ÉÈÊË]/E/g' | sed 's/[éèêë]/e/g')
      title=$(echo $title | sed 's/[ÎÏ]/I/g' | sed 's/[îï]/i/g')
      title=$(echo $title | sed 's/[Ø]/O/g' | sed 's/[ø]/o/g')
      title=$(echo $title | sed 's/[Ö]/Oe/g' | sed 's/[ö]/oe/g')
      title=$(echo $title | sed 's/[Ü]/Ue/g' | sed 's/[ü]/ue/g')
      title=$(echo $title | sed 's/[|]/-/g')

      # write to rds control file
      if [ -z "$title" ]; then
         echo RT "${station}" >>rds_ctl
      else
         echo RT "${title}" >>rds_ctl
      fi
   fi
done < DataPipe
