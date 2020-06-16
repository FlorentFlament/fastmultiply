void generate_multiply_tables(unsigned char *table_plus,
                              unsigned char *table_minus) {
  unsigned short i;
  for (i=0; i < 512; i++) {
    unsigned short m  = i - 256;
    table_plus[i] = i*i >> 6; // %256 is implicit
    table_minus[i] = m*m >> 6;
  }
}
