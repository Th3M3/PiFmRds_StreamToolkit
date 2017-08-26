# PiFmRds_StreamToolkit
<small>ddd</small>

Small script(s) select out of some webradio streams and broadcast them with actual title in Radio Text (RT).


#### fm.sh
This file includes some radio stations to choose. Just run it (`./fm.sh`) without parameters to get asked which station to play or use `./fm.sh [freq] [Stat.Nr]`.
The Stations and the URLs to the mp3 stream are all in `fm.sh`.

`mpg123` is used to play the web stream, because it also reads the ICY-Meta-Info which is the actual played Title.
The Console Output gets piped to `/home/pi/temp.txt`.

#### rds_ctl.sh
The script will be automatically started from fm.sh.
It reads cyclic the `/home/pi/temp.txt` file and creats new radio text entrys in  `/home/pi/rds_ctl`
