/* RESET-interruptin rutiinit.

Kolme eri sorttista toimintoa, riippuen siitä
monesko interrupt-rutiini on kyseessä.
Viimeinen (rutiini_nolla) sammuttaa.
*/

#ifndef RUTIINIT_H
#define RUTIINIT_H

#ifndef __ASSEMBLER__

void rutiini_nolla(void);
void rutiini_1(void);
void rutiini_2(void);

#endif
#endif // RUTIINIT_H