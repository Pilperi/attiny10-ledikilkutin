; SRAM-datat
;
; Laitteella SRAM-datatilaa yhteensä
; 32 tavua, kirjataan kaikki samassa.

#define __SFR_OFFSET 0
#include "data.h"
#include "rekisterit.h"

.global data_painallukset
.global data_sini_kohta
.global data_taajuus
.global data_siniaalto

.global data_lue_siniaalto

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
data_sini_kohta:
    .byte lo8(data_siniaalto + OFFSET_PMEM)
    .byte hi8(data_siniaalto + OFFSET_PMEM)

.section .bss.taajuus                        ; Sinin taajuus
data_taajuus: .byte 0

;############################################
; Funktiot

; Lue siniaaltolistasta seuraava arvo.
; Looppaa listaa tarvittaessa.
;
; Käyttää X, Y, REG_TMP1, REG_TMP2
; Paluuarvo REG_DATA1
.section .text.seuraava_siniarvo
data_lue_siniaalto:
    LDI XL,lo8(data_sini_kohta + OFFSET_SRAM); Lue pointterin osoite
    LDI XH,hi8(data_sini_kohta + OFFSET_SRAM)
    LD YL,X+                                 ; Lue pointterin arvo
    LD YH,X
    LD REG_DATA1,Y+                          ; Lue data pointterista, postinc
    LDI REG_TMP1,lo8(data_siniaalto_end + OFFSET_PMEM)
    LDI REG_TMP2,hi8(data_siniaalto_end + OFFSET_PMEM)
    CP YL,REG_TMP1                           ; Katso tarviiko loopata
    CPC YH,REG_TMP2
    BRNE data_lue_siniaalto_store
    LDI YL,lo8(data_siniaalto + OFFSET_PMEM) ; Looppi alkuun tarvittaessa
    LDI YH,hi8(data_siniaalto + OFFSET_PMEM)
data_lue_siniaalto_store:                    ; Tallenna uusi pointterin arvo
    ST X,YH
    ST -X,YL
    RET
