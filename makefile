SRC := src/fake86
SRCFILES=$(wildcard $(SRC)/*.c)
OBJFILES=$(patsubst $(SRC)/%.c, %.o, $(SRCFILES))

BINPATH=/usr/bin
DATAPATH=/usr/share/fake86
CFLAGS=-Wall -O2 -DPATH_DATAFILES=\"$(DATAPATH)/\" -std=gnu99
INCLUDE=-I$(SRC)
LIBS=-lpthread -lX11
SDLFLAGS=`sdl-config --cflags --libs`

%.o: $(SRC)/%.c
	$(CC) -c $< $(CFLAGS) $(INCLUDE) $(LIBS) $(SDLFLAGS)

all: $(OBJFILES_F86) fake86 imagegen

fake86: $(OBJFILES)
	$(CC) $^ -o $@ $(CFLAGS) $(INCLUDE) $(LIBS) $(SDLFLAGS)
	mv $@ bin

imagegen.o: src/imagegen/imagegen.c
	$(CC) -c $< $(CFLAGS)

imagegen: imagegen.o
	$(CC) $^ -o $@
	mv $@ bin

install:
	mkdir -p $(BINPATH)
	mkdir -p $(DATAPATH)
	chmod a-x data/*
	cp -p bin/fake86 $(BINPATH)
	cp -p bin/imagegen $(BINPATH)
	cp -p data/asciivga.dat $(DATAPATH)
	cp -p data/pcxtbios.bin $(DATAPATH)
	cp -p data/videorom.bin $(DATAPATH)
	cp -p data/rombasic.bin $(DATAPATH)

.PHONY:
clean:
	rm -f *.o
	rm -f src/fake86/*.o
	rm -f src/fake86/*~
	rm -f src/imagegen/*.o
	rm -f src/imagegen/*~
	rm -f bin/fake86
	rm -f bin/imagegen

uninstall:
	rm -f $(BINPATH)/fake86
	rm -f $(BINPATH)/imagegen
