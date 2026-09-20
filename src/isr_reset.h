#ifndef RESET_H
#define RESET_H

// Montako painallusta ennen kuin sammuu
#define N_PAINALLUSTA 3

// C-koodia varten:
#ifndef __ASSEMBLER__

// Reset-handleri
void isr_reset(void);

#endif // C-koodi
#endif // RESET_H
