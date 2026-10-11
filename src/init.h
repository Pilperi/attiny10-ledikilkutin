#ifndef INIT_H
#define INIT_H

// C-koodia varten:
#ifndef __ASSEMBLER__

// Pinnitilojen init (PORTB,DDRB,PUEB)
void init_pinnit(void);

// Datan init (.rodata, .bss)
void init_data(void);

#endif // C-koodi
#endif // INIT_H
