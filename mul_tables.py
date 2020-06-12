#!/usr/bin/env python3

# A variant of the fast signed multiply by Steve Judd & George Taylor
# From the c=hacking9.txt fanzine
# http://www.ffd2.com/fridge/chacking/c=hacking9.txt
# by Florent Flament

# > Ah, now here is something we can fix.  Consider the following function:
# > 
# >       f(x) = x*x/4
# > 
# > Now notice that
# > 
# >       f(a+b) - f(a-b) = a*b
# > 
# > So here is the code to multiply two numbers together:
# > 
# >         * A*Y -> A  Signed, 8-bit result
# > 
# >       STA ZP1         ;ZP1 -- zero page pointer to table of g(x)
# >       EOR #$FF
# >       CLC
# >       ADC #$01
# >       STA ZP2         ;ZP2 also points to g(x)
# >       LDA (ZP1),Y     ;g(Y+A)
# >       SEC
# >       SBC (ZP2),Y     ;g(Y-A)

# Here is the computation we will perform:
#
# Given A in [0..255] and B in [0..255]
# mul(A, B) = round(A*B/16) % 256
#
# We can't use B=0 - Results are incorrect (see below)
#
# Results +/-1 % 256 with 78% accurate results,
# and the following distribution:
# 0 51200
# 1 7168
# 255 7168
class Multiplier:
    def __init__(self):
        # Tables of x**2/64 % 256
        self.__table_plus = [ round(x**2/64) % 256 for x in range(0,511) ]
        self.__table_minus = [ round(x**2/64) % 256 for x in range(-256,256) ]

    def multiply(self, A, B):
        # f(a+b) - f(a-b) = a*b
        def cp_one(B):
            return (256-B) # %256
                           # Because we'd need a cp_one of 256 to use table_minus,
                           # and 256 doesn't fit in 8bits,
                           # We can't use B=0 - Results are incorrect
        fp = self.__table_plus [B+A]
        fm = self.__table_minus [cp_one(B)+A]
        r  = (fp - fm) % 256
        return r

    def errors(self):
        errs = {}
        for A in range(256):
            for B in range(256):
                r = round(A*B/16) % 256
                m = self.multiply(A,B)
                e = (r-m) % 256
                errs[e] = errs.get(e, 0) + 1
        return errs


mul = Multiplier()
errs = mul.errors()

print("Errors distribution:")
for k in sorted(errs.keys()):
    print(k, errs[k])
