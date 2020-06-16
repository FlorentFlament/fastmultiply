A variant of the fast signed multiply by Steve Judd & George Taylor
from the [c=hacking9.txt fanzine][1]

```
> Ah, now here is something we can fix.  Consider the following function:
>
>       f(x) = x*x/4
>
> Now notice that
>
>       f(a+b) - f(a-b) = a*b
>
> So here is the code to multiply two numbers together:
>
>         * A*Y -> A  Signed, 8-bit result
>
>       STA ZP1         ;ZP1 -- zero page pointer to table of g(x)
>       EOR #$FF
>       CLC
>       ADC #$01
>       STA ZP2         ;ZP2 also points to g(x)
>       LDA (ZP1),Y     ;g(Y+A)
>       SEC
>       SBC (ZP2),Y     ;g(Y-A)
```

Here is the computation we will perform on the Commodore 64 (well,
should actually work on any 6502 processor):

```
Given A in [0..255] and B in [1..255]
mul(A, B) = int(A*B/16) % 256
```

Note that the results seem more stable when computing `int(A*B)`
rather tan `round(A*B)`. Both should be usable though.

We can't use B=0; Results are incorrect (see `multiply_tables.py`)

Results are accurate +/-1 % 256 with the following distribution:
* err=0 38656
* err=1 26624

## Compile / Assemble code for C64

```
$ make -r
```

## Run binaries in VICE

```
$ x64sc -autostartprgmode 1 test_fast_multiply
```

or

```
$ x64sc -autostartprgmode 1 verify_multiply_tables
```

## Run the Python reference

```
$ ./multiply_tables.py
```

## Clean everything

```
$ make clean
```

[1]: http://www.ffd2.com/fridge/chacking/c=hacking9.txt
