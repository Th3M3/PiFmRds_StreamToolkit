#!/bin/sh
#Make sure PiFmRDS is installed. Check github.com/ChristopheJacquet/PiFmRds for Details."

NONE='\033[00m'
RD='\033[01;31m'
BL='\033[01;34m'
GN='\033[01;32m'
YE='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
X_UNDERLINE='\033[24m'


if [ -z $1 ]
  then
    echo
    echo " [${BL}i${NONE}] Frequency is not given. Using default (108.0MHz)"
    FREQ=108.0
  elif [ $1 = "--help" ]
    then
      echo `basename "$0"`" - sends an audio web stream via PiFMRDS"
      echo
      echo "usage: `basename "$0"` [frequency] [Stream No]"
      echo
      echo "Options: frequency            FM frequency in MHz, between 76 and 108."
      echo "         Stream No            pre-choose one of the radio streams."
      echo ""
      echo "Streams:"
  else
    echo
    echo " [${BL}i${NONE}] Set transmit Frequency to $1MHz"
    FREQ=$1
fi

if [ -z $1 ] || [ $1 != "--help" ] && [ -z $2 ]; then
    echo " ${BOLD}"
    echo " Select Radio Station:"
    echo
fi

if [ -z $2 ]
then
  echo " ${UNDERLINE}1${X_UNDERLINE}: M1 FM Charts"
  echo " ${UNDERLINE}2${X_UNDERLINE}: Jam FM - New Music Radio"
  echo " ${UNDERLINE}3${X_UNDERLINE}: Kronehit 90's Dance"
  echo " ${UNDERLINE}4${X_UNDERLINE}: Energy Acoustic Hits"
  echo " ${UNDERLINE}5${X_UNDERLINE}: Sunshine EDM"
  echo " ${UNDERLINE}6${X_UNDERLINE}: M1 FM Urban"

  echo " ${NONE}"
  echo -n " >"
fi

if [ ! -z $1 ] && [ $1 = "--help" ]; then
  exit
fi

if [ -z $2 ]
then
  read n
else
  echo " [${BL}i${NONE}] Station $2 choosen by parameter"
  n=$2
fi

case $n in
    1) STATION_URL="http://tuner.m1.fm/charts.mp3";                     RDS_PS="  M1 FM ";VOL=0.4;RDS_RT="Charts";;
    2) STATION_URL="http://stream.jam.fm/jamfm-nmr/mp3-128/";           RDS_PS=" JAM FM ";VOL=0.8;RDS_RT="New Music Radio";;
    3) STATION_URL="http://onair-ha1.krone.at/kronehit-90sdance.mp3";   RDS_PS="90 DANCE";VOL=0.8;RDS_RT="Kronehit 90's Dance";;
    4) STATION_URL="http://cdn.nrjaudio.fm/adwz1/de/33051/mp3_128.mp3"; RDS_PS=" ENERGY ";VOL=0.6;RDS_RT="Energy Acoustic Hits";;
    5) STATION_URL="http://stream.sunshine-live.de/edm/mp3-192"         RDS_PS="SUNSHINE";VOL=0.4;RDS_RT="EDM";;
    6) STATION_URL="http://tuner.m1.fm/urban.mp3"                       RDS_PS="  M1 FM ";VOL=0.4;RDS_RT="Urban";;
    *) invalid option;;
esac

while [ 1 ]
do
  echo
  echo " [${BL}i${NONE}] ${GN}Starting FM Radio Station..."
  echo -n "${NONE}"
  time_start=$(date +%s)
  echo -n "     ${YE}The time is currently: "; date
  echo "${NONE}"

  echo >rds_ctl
  mpg123 --buffer 2048 -s "$STATION_URL" 2>temp.txt | sox -v "$VOL" -t raw -b 16 -e signed -c 2 -r 44100 - -t wav - highpass 50 treble +8 | sudo ../PiFmRds/src/pi_fm_rds -pi 1009 -freq "$FREQ" -ps "$RDS_PS" -rt "$RDS_RT" -ctl rds_ctl -audio -  & ./rds_ctl.sh

  time_stop=$(date +%s)
  timediff=$(( $time_stop - $time_start -3600 ))
  
  echo -n " [${BL}i${NONE}] ${RD}Process Exited${NONE}, TIME: "; date;
  echo -n "     ${YE}Program was running for "; date --date @$timediff +'%H:%M:%S';
  echo -n "${NONE}"
done
