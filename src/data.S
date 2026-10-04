; SRAM-datat
;
; Laitteella SRAM-datatilaa yhteensä
; 32 tavua, kirjataan kaikki samassa.

#define __SFR_OFFSET 0
#include "data.h"

.global data_painallukset
.global data_sini_kohta
.global data_taajuus
.global data_sin

.section .data.painallukset                  ; RESET-interruptien määrä
data_painallukset: .byte DATA_N_PAINALLUSTA  ; 1 tavu, 31 jäljellä

.section .data.sini_kohta                    ; Paikka siniaallossa
data_sini_kohta: .byte 0                     ; 1 tavu, 30 jäljellä

.section .data.sini_askelkoko                ; Sinin taajuus
data_taajuus: .byte 0                        ; 1 tavu, 29 jäljellä

.section .data.siniaalto                     ; Siniaallon arvot
data_sin:                                    ; 28 tavua, 1 jäljellä
    .byte 132,159,185,208
    .byte 228,242,251,255
    .byte 251,242,228,208
    .byte 185,159,132,105
    .byte  79, 56, 36, 22
    .byte  13, 10, 13, 22
    .byte  36, 56, 79,105
