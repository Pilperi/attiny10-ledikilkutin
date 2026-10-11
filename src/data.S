; SRAM-datat
;
; Laitteella SRAM-datatilaa yhteensä
; 32 tavua, kirjataan kaikki samassa.

#define __SFR_OFFSET 0
#include "data.h"

.global data_painallukset
.global data_sini_kohta
.global data_taajuus
.global data_siniaalto

.section .data.painallukset                  ; RESET-interruptien määrä
data_painallukset: .byte DATA_N_PAINALLUSTA

.section .rodata.siniaalto                   ; Siniaallon arvot 32 tavua
data_siniaalto:
    .byte 132, 156, 179, 200
    .byte 219, 234, 245, 252
    .byte 255, 252, 245, 234
    .byte 219, 200, 179, 156
    .byte 132, 108,  85,  64
    .byte  45,  30,  19,  12
    .byte  10,  12,  19,  30
    .byte  45,  64,  85, 108
data_siniaalto_end:

.section .data.sini_kohta                    ; Paikka siniaallossa (osoite)
data_sini_kohta: .word data_siniaalto

.section .bss.taajuus                        ; Sinin taajuus
data_taajuus: .byte 0