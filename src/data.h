#ifndef DATA_H
#define DATA_H

// Montako painallusta ennen kuin sammuu
#define DATA_N_PAINALLUSTA 3
#define DATA_SIN_PITUUS 32

// C-koodi
#ifndef __ASSEMBLER__
#include <stdint.h>

extern uint8_t data_painallukset;
extern uint8_t data_sini_kohta;
extern uint8_t data_taajuus;
extern const uint8_t data_siniaalto[32] __attribute__((progmem));

#endif // C-koodi
#endif // DATA_H
