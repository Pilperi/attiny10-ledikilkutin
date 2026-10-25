#ifndef DATA_H
#define DATA_H

/* Muistiosotteiden offsetit */
#define OFFSET_PMEM 0x4000
#define OFFSET_SRAM 0x0000

#define pmem_lo(addr) lo8(addr + OFFSET_PMEM)
#define pmem_hi(addr) hi8(addr + OFFSET_PMEM)
#define fpointer_lo(addr) lo8(gs(addr + OFFSET_PMEM))
#define fpointer_hi(addr) hi8(gs(addr + OFFSET_PMEM))
#define sram_lo(addr) lo8(addr + OFFSET_SRAM)
#define sram_hi(addr) hi8(addr + OFFSET_SRAM)

// Montako painallusta ennen kuin sammuu
#define DATA_N_PAINALLUSTA 4

// C-koodi
#ifndef __ASSEMBLER__
#include <stdint.h>

/* Montako painallusta jäljellä */
extern uint8_t data_painallukset;

/* Siniaallon nykyinen kohta (osoite) */
extern uint8_t data_sini_kohta;

/* Siniaallon etenemistaajuus, kauanko arvo pidetään */
extern uint8_t data_taajuus;

/* Itse siniaallon arvot (PMEM puolella) */
extern const uint8_t data_siniaalto[32] __attribute__((progmem));

/* Lukee seuraavan siniaallon arvon REG_DATA1 */
void data_lue_siniaalto(void);

#endif // C-koodi
#endif // DATA_H
