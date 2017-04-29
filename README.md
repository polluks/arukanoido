# Arukanoido

https://en.wikipedia.org/wiki/Arkanoid/

This is an Arkanoid clone for the Commodore VIC–20 with at least 16K
memory expansion.  It should be played with paddles which are detected
automatically.

Arukanoido is discussed and developed on the VIC–20 Denial forum:
http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?t=3752

You've probably found these files here:
https://github.com/SvenMichaelKlose/arukanoido/


# Rolling your own

You can find the latest binary 'arukanoido.prg' in this directory.
You need a Linux machine to build your own Arukanoido.  Steel Bank
Common Lisp AKA 'sbcl' is required.  Launch 'download-and-install.sh'
in an empty directory and it'll clone everything and build it.


# Things missing:

* No sound.
* No two-player mode.
* No intro or extra graphics.
* Round 33 is missing.
* No animated sprites.
* No distractions floating down.
* No B or E bonuses although they show.
* No title screen nor intro.


# Applications used

## beamrider's "VIC–20 Screen and Character Designer"

URL: http://87.81.155.196/vic20sdd/Vic20SDD.htm

Discussion: http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=14&t=7133

## Mike's "MINIPAINT" and "MINIGRAFIK"

URL: https://cid-05ef0a8eae2a4f4a.onedrive.live.com/self.aspx/.Public/denial/minigrafik/

Discussion: http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=2&t=3752

## pixel's assembler "bender"

URL: https://github.com/SvenMichaelKlose/bender/

Discussion: http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=2&t=7072


# Other applications

## VICE – the Versatile Commodore Emulator

URL: http://vice-emu.sourceforge.net/


# Contributions

This project has been initiated by Sabine Kuhn <eimer@devcon.net>.
Contributions are listed by time.

Code has been contributed by Sven Michael Klose <pixel@hugbox.org>.

src-media/character.txt has been created with beamrider's VIC—20 Screen
and Character Designer by pixel:
http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=14&t=7133

src-media/doh.prg has been contributed by Mike. He created it
with his VIC–20 editor MINIPAINT (there must be no ,1 in the LOAD command).

src-media/intro-sequence.txt has been contributed by beamrider using his
VIC–20 Screen and Character Designer.

src-media/ark-title.prg has been contributed by tokra with help of
Mike's MINIGRAFIK. Also no ,1 in the LOAD command.

sound.bin and sound-beamrider have been contributed by beamrider.
