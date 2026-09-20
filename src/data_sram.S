; SRAM-datat
;
; Laitteella SRAM-datatilaa yhteensä
; 32 tavua, kirjataan kaikki samassa.

#define __SFR_OFFSET 0

.global data_painallukset
.global data_sini_1
.global data_sini_2

.section .data
data_painallukset: .byte 4                   ; RESET-interruptien määrä

.section .bss
data_sini_1: .space 15                       ; Siniaalto hidas (TODO)
data_sini_2: .space 15                       ; Siniaalto nopea
