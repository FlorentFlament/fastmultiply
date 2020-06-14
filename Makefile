all: verify_multiply_tables

verify_multiply_tables: verify_multiply_tables.c generate_multiply_tables.c
	cl65 -t c64 $^

run: verify_multiply_tables
	x64sc -autostartprgmode 1 $<

clean:
	rm -f verify_multiply_tables.c generate_multiply_tables.c
