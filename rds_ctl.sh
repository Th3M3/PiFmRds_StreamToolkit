#!/bin/sh

EscapeChars() {
   # replace characters to valid RDS-Charset
   # first whole words
   ret=$(echo $1 | sed 's/$ign/Sign/g')
   ret=$(echo $ret | sed 's/P!nk/Pink/g')

   # characters a, e, i, o, u
   ret=$(echo $ret | sed 's/[ÀÂ]/A/g' | sed 's/[àâ]/a/g')
   ret=$(echo $ret | sed 's/[Ä]/Ae/g' | sed 's/[ä]/ae/g')
   ret=$(echo $ret | sed 's/[ÉÈÊË]/E/g' | sed 's/[éèêë]/e/g')
   ret=$(echo $ret | sed 's/[ÎÏ]/I/g' | sed 's/[îï]/i/g')
   ret=$(echo $ret | sed 's/[Ø]/O/g' | sed 's/[ø]/o/g')
   ret=$(echo $ret | sed 's/[Ö]/Oe/g' | sed 's/[ö]/oe/g')
   ret=$(echo $ret | sed 's/[Ü]/Ue/g' | sed 's/[ü]/ue/g')

   # special characters
   ret=$(echo $ret | sed 's/[|]/-/g')
   ret=$(echo $ret | sed 's/[&]/+/g')


   # shorten text if it's too long (remove strings in Brackets)
   if [ "${#ret}" -gt 50 ];
   then
      ret=$(echo $ret | sed 's/ feat. /, /g')
      ret=$(echo $ret | sed 's/ featuring / feat. /g') | sed 's/Featuring /Feat. /g')

      ret=$(echo $ret | sed 's/[[A-Z a-z]*] //g')
      ret=$(echo $ret | sed 's/([A-Z a-z]*) //g')
      ret=$(echo $ret | sed 's/{[A-Z a-z]*} //g')
   fi
}

# read from DataPipe and parse meta data
while read line;
do
   # catch Stream's Station Name
   if [ "$(echo "$line" | cut -c 1-9)" = 'ICY-NAME:' ];
   then
      EscapeChars "$(echo $line | cut -c11-)"
      station=$ret
   fi

   # catch Stream's Current Title
   if [ "$(echo "$line" | cut -c 1-9)" = 'ICY-META:' ];
   then
      # parse meta data from line
      title=$(echo $line | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="StreamTitle"{print $2}' | cut -c 2- | sed 's/..$//')

      EscapeChars "$title"

      # write to rds control file
      if [ -z "$title" ];
      then
         # write Station Name if there is currently no Title Info
         echo RT "${station}" >>rds_ctl
      else
         # write Title Info if it has changed
         if [ "$title" != "$title_old" ];
         then
            echo RT "${ret}" >>rds_ctl
            title_old=$title
         fi
      fi
   fi
done < DataPipe
