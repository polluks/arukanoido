TITLE=MusicTester

#set -e

mkdir -p obj
rm -f obj/*

ca65 --cpu 6502 -t vic20 --listing music.lst --include-dir . -g $TITLE.s
ca65 --cpu 6502 -t vic20 --listing music.lst --include-dir . -g music.i
ca65 --cpu 6502 -t vic20 --listing player.lst --include-dir . -g player.s
ld65 -C basic-8k.cfg -Ln $TITLE.sym -m $TITLE.map -o $TITLE.prg $TITLE.o player.o music.o

mv *.o obj
mv *.sym obj
mv *.map obj
mv *.lst obj
