#!/usr/bin/env python3

class Multiplier:
    def __init__(self):
        # Tables of x**2/64 % 256
        # Technically speaking, the tables need to be 511 bytes long,
        # it's just more conveninent later one like that.
        self.__table_plus = [ int(x**2/64) % 256 for x in range(0,512) ]
        self.__table_minus = [ int(x**2/64) % 256 for x in range(-256,256) ]

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
            for B in range(1,256):
                r = int(A*B/16) % 256
                m = self.multiply(A,B)
                e = (m-r) % 256
                errs[e] = errs.get(e, 0) + 1
        return errs

    def dump_c_tables(self):
        print("\nunsigned char ref_table_plus[] = {{{}}};".format(
            ','.join((str(i) for i in self.__table_plus))))
        print("\nunsigned char ref_table_minus[] = {{{}}};".format(
            ','.join((str(i) for i in self.__table_minus))))


mul = Multiplier()
errs = mul.errors()

print("Errors distribution:")
for k in sorted(errs.keys()):
    print(k, errs[k])

mul.dump_c_tables()
