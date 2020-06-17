C_SRC=generate_multiply_tables.c test_fast_multiply.c verify_multiply_tables.c
S_SRC=fast_multiply.s
BIN=test_fast_multiply.prg verify_multiply_tables.prg

all: $(BIN)

%.s: %.c
	cc65 -g --target c64 $<

%.o: %.s
	ca65 -g $<

%.prg:
	ld65 --config c64.cfg \
	     --mapfile $(patsubst %.prg, %.map, $@) \
	     --dbgfile $(patsubst %.prg, %.dbg, $@) \
	     -Ln $(patsubst %.prg, %.lbl, $@) \
	     -o $@ \
             $^ c64.lib

verify_multiply_tables.prg: verify_multiply_tables.o generate_multiply_tables.o

test_fast_multiply.prg: test_fast_multiply.o fast_multiply.o generate_multiply_tables.o

clean:
	rm -f $(patsubst %.c, %.s, $(C_SRC)) \
	      $(patsubst %.c, %.o, $(C_SRC)) \
	      $(patsubst %.s, %.o, $(S_SRC)) \
	      $(patsubst %.prg, %.dbg, $(BIN)) \
	      $(patsubst %.prg, %.map, $(BIN)) \
	      $(patsubst %.prg, %.lbl, $(BIN)) \
	      $(BIN)
