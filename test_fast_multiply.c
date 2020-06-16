#include <stdio.h>

unsigned char fast_multiply(unsigned char b, unsigned char a);
void generate_multiply_tables(unsigned char *table_plus,
                              unsigned char *table_minus);

// Use aligned BSS segment
#pragma bss-name (push, "TABLES")
unsigned char mult_table_plus[512];
unsigned char mult_table_minus[512];
#pragma bss-name (pop)

unsigned short ref_distrib[]= {38656, 26624, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

// This will be initialized to 0, cause BSS
unsigned short deltas_vec[256];

void main(void) {
  unsigned short a;
  unsigned short b;
  unsigned char ref;
  unsigned char mul;
  unsigned char flag=0;

  generate_multiply_tables(mult_table_plus, mult_table_minus);

  for (a=0; a<256; a++) {
    for (b=1; b<256; b++) {
      ref = a*b/16;
      mul = fast_multiply(b, a);
      deltas_vec[(256+mul-ref) % 256]++;
      // printf("a=%u b=%u r=%u m=%u\n", a, b, ref, mul);
    }
    printf(".");
  }

  // Displaying deltas distribution
  printf("\n");
  for (a=0; a<256; a++) {
    if (deltas_vec[a] != 0) {
      printf("deltas_vec[%u] = %u\n", a, deltas_vec[a]);
    }
  }

  // Checking deltas distribution against reference
  for (a=0; a<256; a++) {
    if (deltas_vec[a] != ref_distrib[a]) {
      printf("\n*** Failure ***\nThe deltas distribution doesn't match the reference.\n");
      flag = 1;
      break;
    }
  }
  if ( flag == 0 ) {
    printf("\n*** Success ***\nThe deltas distribution matches the reference.\n");
  }
}
