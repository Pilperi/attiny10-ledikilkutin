; Toimintamoodit/rutiinit
;
; Eri tilat joihin laite menee resetillä.
; Rutiini 1:
;    TBD (himmeä?)
; Rutiini 2:
;    TBD (kirkas? siniaalto?)
; Rutiini 0:
;    Katkaise virrat

#define __SFR_OFFSET 0
#include <avr/io.h>
#include "rutiinit.h"
#include "pinnit.h"
#include "rekisterit.h"

.global rutiini_nolla
.global rutiini_1
.global rutiini_2

.section .text.rutiinit
rutiini_2:
    LDI REG_TMP1,(1<<PIN_ENABLE)|(1<<PIN_PUNA)
    RJMP rutiini_set
rutiini_1:
    LDI REG_TMP1,(1<<PIN_ENABLE)|(1<<PIN_SINI)
    RJMP rutiini_set
rutiini_nolla:
    LDI REG_TMP1,0x00
rutiini_set:
    OUT PORTB,REG_TMP1
    OUT DDRB,REG_TMP1
    OUT PUEB,REG_TMP1
    CPSE REG_TMP1,REG_ZERO
    RJMP main
rutiini_nolla_loop:                          ; Ikuinen loop
    SLEEP
    RJMP rutiini_nolla_loop
