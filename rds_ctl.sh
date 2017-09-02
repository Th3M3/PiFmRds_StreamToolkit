#!/bin/sh

EscapeChars() {
   # replace characters to get a valid RDS-Charset
   # first whole words
   ret=$(echo $1 | sed 's/$ign/Sign/g')
   ret=$(echo $ret | sed 's/P!nk/Pink/g')

   # characters a, e, i, o, u
   ret=$(echo $ret | sed 's/[ÀÁÂ]/A/g' | sed 's/[àáâ]/a/g')
   ret=$(echo $ret | sed 's/[Ä]/Ae/g' | sed 's/[ä]/ae/g')
   ret=$(echo $ret | sed 's/[ÉÈÊË]/E/g' | sed 's/[éèêë]/e/g')
   ret=$(echo $ret | sed 's/[ÌÍÎÏ]/I/g' | sed 's/[ìíîï]/i/g')
   ret=$(echo $ret | sed 's/[ÒÓØ]/O/g' | sed 's/[òóø]/o/g')
   ret=$(echo $ret | sed 's/[Ö]/Oe/g' | sed 's/[ö]/oe/g')
   ret=$(echo $ret | sed 's/[ÙÚ]/U/g' | sed 's/[ùú]/ue/g')
   ret=$(echo $ret | sed 's/[Ü]/Ue/g' | sed 's/[ü]/ue/g')

   # special characters
   ret=$(echo $ret | sed 's/[|]/-/g')
   ret=$(echo $ret | sed 's/[&]/+/g')
   ret=$(echo $ret | sed 's/[§$%]//g')

   # try to shorten string if it is too long (short strings)
   if [ ${#ret} -gt 50 ];
   then
      ret=$(echo $ret | sed 's/ feat. /; /g')
      ret=$(echo $ret | sed 's/ featuring / feat. /g' | sed 's/Featuring /Feat. /g')
   fi

   # try to shorten more if it is still too long (remove strings in Brackets)
   if [ ${#ret} -gt 50 ];
   then
      ret=$(echo $ret | sed 's/ [[A-Z a-z]*]//g')
      ret=$(echo $ret | sed 's/ ([A-Z a-z]*)//g')
      ret=$(echo $ret | sed 's/ {[A-Z a-z]*}//g')
   fi
}

# read from DataPipe and parse meta data
while read line;
do
   # catch Stream's Station Name
   if [ "$(echo "$line" | cut -c 1-9)" = 'ICY-NAME:' ];
   then
      station=$(echo $line | cut -c11-)
   fi

   # catch Stream's Current Title
   if [ "$(echo "$line" | cut -c 1-9)" = 'ICY-META:' ];
   then
      # parse meta data from line
      title=$(echo "$line" | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="StreamTitle"{print $2}' | cut -c 2- | sed 's/..$//')

      # use Station Name if there is currently no Title Info
      if [ -z "$title" ] || [ "$title" = " " ];
      then
         title="$station"
      fi

      # write Title Info if it has changed
      if [ "$title" != "$title_old" ];
      then
         EscapeChars "$title"
         echo RT "$ret" >>rds_ctl
         title_old="$title"
      fi
   fi
done < DataPipe
