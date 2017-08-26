# PiFmRds_StreamToolkit

Small script(s) select out of some webradio streams and broadcast them with actual title in Radio Text (RT).


#### fm.sh
This file includes some radio stations to choose. Just run it (`./fm.sh`) without parameters to get asked which station to play or use `./fm.sh [freq] [Stat.Nr]`.
The Stations and the URLs to the mp3 stream are all in `fm.sh`.

`mpg123` is used to play the web stream, because it also reads the ICY-Meta-Info (the actual played Title)
It's Console Output gets piped to `/home/pi/temp.txt` for processing the radio text.

`sox` is only used to convert the stream to `wav` and to adjust the equalizer and volume.

I have built in a loop. If `PiFmRds` stops broadcasting, it will restarted automatically.
Use `Strg + C` to exit.

#### rds_ctl.sh
The script will be automatically started from fm.sh.
It reads cyclic the `/home/pi/temp.txt` file and creats new radio text entries in  `/home/pi/rds_ctl`


###### Make sure <a href="http://github.com/ChristopheJacquet/PiFmRds">PiFmRds</a> and mpg123 is installed. I am run it on a Raspberry Pi 3.
