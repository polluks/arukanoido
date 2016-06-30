@echo off
cd %~dp0
set TITLE=MusicTester

md obj > NUL
md bin > NUL
del obj\*.* /q
del bin\*.* /q

@echo on
ca65.exe --cpu 6502 -t vic20 --listing --include-dir . -g basic.s
@echo off
IF ERRORLEVEL 1 goto errorRoutine

@echo on
ca65.exe --cpu 6502 -t vic20 --listing --include-dir . -g %TITLE%.s
@echo off
IF ERRORLEVEL 1 goto errorRoutine

@echo on
ca65.exe --cpu 6502 -t vic20 --listing --include-dir . -g music.i
@echo off
IF ERRORLEVEL 1 goto errorRoutine

@echo on
ca65.exe --cpu 6502 -t vic20 --listing --include-dir . -g player.s
@echo off
IF ERRORLEVEL 1 goto errorRoutine

@echo on
ld65.exe -C basic-8k.cfg -Ln %TITLE%.sym -m %TITLE%.map -o %TITLE%.prg %TITLE%.o basic.o  music.o player.o
@echo off
IF ERRORLEVEL 1 goto errorRoutine
@echo off

move *.o obj > NUL
move *.sym obj > NUL
move *.map obj > NUL
move *.lst obj > NUL
move *.prg bin > NUL

"\cbmdev\PokefinderVICE\WinVICE-2.4.20.29773-x64\xvic.exe"  -memory 24k bin\%TITLE%.prg 

exit

:errorRoutine
@echo !!!!Build Error!!!
:pause
exit



