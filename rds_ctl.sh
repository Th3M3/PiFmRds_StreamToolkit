#!/bin/sh

EscapeChars() {
#echo In: $1
   # replace characters to valid RDS-Charset
   ret=$(echo $1 | sed 's/[ÀÂ]/A/g' | sed 's/[àâ]/a/g')
   ret=$(echo $ret | sed 's/[Ä]/Ae/g' | sed 's/[ä]/ae/g')
   ret=$(echo $ret | sed 's/[ÉÈÊË]/E/g' | sed 's/[éèêë]/e/g')
   ret=$(echo $ret | sed 's/[ÎÏ]/I/g' | sed 's/[îï]/i/g')
   ret=$(echo $ret | sed 's/[Ø]/O/g' | sed 's/[ø]/o/g')
   ret=$(echo $ret | sed 's/[Ö]/Oe/g' | sed 's/[ö]/oe/g')
   ret=$(echo $ret | sed 's/[Ü]/Ue/g' | sed 's/[ü]/ue/g')
   ret=$(echo $ret | sed 's/[|]/-/g')
#echo Out1: $ret
   # short text it it's too long (remove strings in Brackets)
   if [ "${#ret}" -gt 60 ];
   then
      ret=$(echo $ret | sed 's/[[A-Z a-z]*] //g')
      ret=$(echo $ret | sed 's/([A-Z a-z]*) //g')
      ret=$(echo $ret | sed 's/{[A-Z a-z]*} //g')
#echo Out2: $ret
   fi
}

# read from DataPipe and parse meta data
while read line;
do
   # catch Station Name
   if [ "$(echo "$line" | cut -c 1-9)" = 'ICY-NAME:' ];
   then
      EscapeChars "$(echo $line | cut -c11-)"
      station=$ret
   fi

   # catch Stream current Title
   if [ "$(echo "$line" | cut -c 1-9)" = 'ICY-META:' ];

   then
      # parse meta data from line
      title=$(echo $line | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="StreamTitle"{print $2}' | cut -c 2- | sed 's/..$//')

      EscapeChars "$title"


      # write to rds control file
      if [ -z "$title" ]; then
         echo RT "${station}" >>rds_ctl
      else
         echo RT "${ret}" >>rds_ctl
      fi
   fi
done < DataPipe
