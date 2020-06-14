void generate_multiply_tables(unsigned char *table_plus,
                              unsigned char *table_minus) {
  unsigned short int i;

  // Populating generated tables
  for (i=0; i < 512; i++) {
    unsigned short m  = i - 256;
    unsigned short p2 = i * i;
    unsigned short m2 = m * m;

    // Rounding numbers rather than truncating them
    table_plus[i] = p2/64; // %256 is implicit since table_plus[i] is a (unsigned) char
    if( (p2 & 0x3f) > 32 ) table_plus[i]++;

    table_minus[i] = m2/64;
    if( (m2 & 0x3f) > 32 ) table_minus[i]++;
  }
}
