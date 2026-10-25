; SRAM-datat
;
; Laitteella SRAM-datatilaa yhteensä 32 tavua, kirjataan kaikki samassa.

#define __SFR_OFFSET 0
#include "data.h"
#include "rekisterit.h"

.global data_painallukset
.global data_sini_kohta
.global data_taajuus
.global data_siniaalto
.global data_siniaalto_end
.global data_addr_rutiini
.global seuraava_siniarvo

.section .data.painallukset                  ; RESET-interruptien määrä
data_painallukset: .byte DATA_N_PAINALLUSTA

.section .rodata.siniaalto                   ; Siniaallon arvot 32 tavua
data_siniaalto:
    .byte 127, 152, 176, 198
    .byte 217, 233, 245, 252
    .byte 255, 252, 245, 233
    .byte 217, 198, 176, 152
    .byte 127, 102,  78,  56
    .byte  37,  21,   9,   2
    .byte   0,   2,   9,  21
    .byte  37,  56,  78, 102
data_siniaalto_end:

.section .data.sini_kohta                    ; Paikka siniaallossa (osoite)
data_sini_kohta:
    .byte hi8(data_siniaalto + OFFSET_PMEM)
    .byte lo8(data_siniaalto + OFFSET_PMEM)

.section .data.taajuus                       ; Sinin taajuus
data_taajuus: .byte 50

.section .bss.addr_rutiini
data_addr_rutiini:
    .space 2
    
;############################################
; Funktiot

; Lue siniaaltolistasta seuraava arvo.
; Looppaa listaa tarvittaessa.
;
; Käyttää Y, REG_TMP1, REG_TMP2
; Paluuarvo REG_DATA1
.section .text.seuraava_siniarvo
seuraava_siniarvo:
    PUSH YH
    PUSH YL
    LDS YH,(data_sini_kohta)
    LDS YL,(data_sini_kohta+1)
    LD REG_DATA1,Y+
    LDI REG_TMP1,pmem_lo(data_siniaalto_end)
    LDI REG_TMP2,pmem_hi(data_siniaalto_end)
    CP YL,REG_TMP1
    CPC YH,REG_TMP2
    BRNE seuraava_siniarvo_store
    LDI YL,pmem_lo(data_siniaalto)
    LDI YH,pmem_hi(data_siniaalto)
seuraava_siniarvo_store:
    STS (data_sini_kohta+1),YL
    STS (data_sini_kohta),YH
    POP YL
    POP YH
    RET
