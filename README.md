# PiFmRds_StreamToolkit

Small script(s) to select out of some self-defined webradio streams and broadcast them with actual title in Radio Text (RT).

<img alt="console screenshot" src="https://raw.githubusercontent.com/Th3M3/PiFmRds_StreamToolkit/master/img/console.JPG" width="70%"/>


```
git clone https://github.com/Th3M3/PiFmRds_StreamToolkit.git
cd PiFmRds_StreamToolkit
chmod +x *.sh
./fm.sh
```

<br><b>fm.sh</b> includes some radio stations to choose. Just run it (`./fm.sh`) without parameters to get asked which station to play or use `./fm.sh [freq] [Stat.Nr]`.
The Stations and the URLs to the mp3 stream are all in `fm.sh`.

`mpg123` is used to play the web stream, because it also reads the ICY-Meta-Info (the actual played Title)
It's Console Output gets piped to `/home/pi/temp.txt` for processing the radio text.

`sox` is only used to convert the stream to `wav` and to adjust the equalizer and volume.

I have built in a loop. If `PiFmRds` stops broadcasting, it will restarted automatically.
Use `Strg + C` to exit.


<br><b>rds_ctl.sh</b> will be automatically started from fm.sh.
It reads the `/home/pi/temp.txt` file in cycle and creats new radio text entries in  `/home/pi/rds_ctl`

---
###### Make sure <a href="http://github.com/ChristopheJacquet/PiFmRds">PiFmRds</a> and mpg123 is installed. I have tested it on Raspberry Pi 3.
###### For better sound quality I have also changed the low-pass-cutoff-frequency in PiFmRds to 20000Hz.
