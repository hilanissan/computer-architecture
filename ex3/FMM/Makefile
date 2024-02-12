CC = gcc
CFLAGS = -Wall -Wextra
PYTHON = python3
MKDIR_P = mkdir -p

all: fmm

fmm: main.o fmm.o utilities.o
	$(CC) $(CFLAGS) -o fmm main.o fmm.o utilities.o

main.o: main.c fmm.h
	$(CC) $(CFLAGS) -c main.c

fmm.o: fmm.c fmm.h
	$(CC) $(CFLAGS) -c fmm.c

utilities.o: utilities.c 
	$(CC) $(CFLAGS) -c utilities.c

create_matrices:
	$(PYTHON) create-matrices.py

.PHONY: clean
clean:
	rm -f fmm *.o
