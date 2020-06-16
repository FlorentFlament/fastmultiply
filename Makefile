C_SRC=generate_multiply_tables.c test_fast_multiply.c verify_multiply_tables.c
S_SRC=fast_multiply.s
BIN=test_fast_multiply verify_multiply_tables

all: $(BIN)

%.s: %.c
	cc65 -g --target c64 $<

%.o: %.s
	ca65 -g $<

verify_multiply_tables: verify_multiply_tables.o generate_multiply_tables.o
	ld65 --config c64.cfg \
	     --mapfile $@.map \
	     --dbgfile $@.dbg \
	     -Ln $@.lbl \
	     -o $@ \
             $^ c64.lib

test_fast_multiply: test_fast_multiply.o fast_multiply.o generate_multiply_tables.o
	ld65 --config c64.cfg \
	     --mapfile $@.map \
	     --dbgfile $@.dbg \
	     -Ln $@.lbl \
	     -o $@ \
	     $^ c64.lib

clean:
	rm -f $(patsubst %.c, %.s, $(C_SRC)) \
	      $(patsubst %.c, %.o, $(C_SRC)) \
	      $(patsubst %.s, %.o, $(S_SRC)) \
	      $(patsubst %, %.dbg, $(BIN)) \
	      $(patsubst %, %.map, $(BIN)) \
	      $(patsubst %, %.lbl, $(BIN)) \
	      $(BIN)
