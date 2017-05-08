@echo off
cd %~dp0
set TITLE=ArkSound

md obj > NUL
md bin > NUL
del obj\*.* /q
del bin\*.* /q

@echo on
ca65.exe --cpu 6502 -t vic20 --listing --include-dir . -g player.s
@echo off
IF ERRORLEVEL 1 goto errorRoutine

@echo on
ca65.exe --cpu 6502 -t vic20 --listing --include-dir . -g music.i
@echo off
IF ERRORLEVEL 1 goto errorRoutine

@echo on
ld65.exe -C basic-8k.cfg music.o player.o -Ln %TITLE%.sym -m %TITLE%.map -o %TITLE%.bin  
@echo off
IF ERRORLEVEL 1 goto errorRoutine
@echo off


move *.o obj > NUL
move *.sym obj > NUL
move *.map obj > NUL
move *.lst obj > NUL
move *.prg bin > NUL
move *.bin bin > NUL

exit

:errorRoutine
@echo !!!!Build Error!!!
:pause
exit



