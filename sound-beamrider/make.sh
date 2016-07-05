TITLE=MusicTester

#set -e

mkdir -p obj
rm -f obj/*

ca65 --cpu 6502 -t vic20 --listing basic.lst --include-dir . -g basic.s
ca65 --cpu 6502 -t vic20 --listing $TITLE.lst --include-dir . -g $TITLE.s
ca65 --cpu 6502 -t vic20 --listing music.lst --include-dir . -g music.i
ca65 --cpu 6502 -t vic20 --listing player.lst --include-dir . -g player.s
ld65 -C basic-8k.cfg -Ln $TITLE.sym -m $TITLE.map -o $TITLE.prg $TITLE.o basic.o  music.o player.o

mv *.o obj
mv *.sym obj
mv *.map obj
mv *.lst obj
