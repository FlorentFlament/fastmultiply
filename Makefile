all:
	cl65 -t c64 mul_tables.c

run:
	x64sc -autostartprgmode 1 mul_tables

clean:
	rm -f mul_tables mul_tables.o
