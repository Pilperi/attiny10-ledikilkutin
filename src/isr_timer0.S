#define __SFR_OFFSET 0
#include <avr/io.h>
#include "isr_timer0.h"
#include "pinnit.h"
#include "rekisterit.h"

.global isr_timer0_ovf
.global isr_timer0_setup

.section .text.isr.isr_timer0_siniaalto
isr_timer0_lue_siniaalto:
    LDI XL,lo8(data_sini_kohta)              ; Lue missä kohtaa siniaaltoa
    LDI XH,hi8(data_sini_kohta)              ; tällä hetkellä ollaan.
    LD YL,X+                                 ; Lue pointerin arvo
    LD YH,X
    LD REG_DATA1,Y+                          ; Lue sinin arvo osoitteesta ja
    LDI ZL,lo8(data_siniaalto_end)           ; katso ettei seuraava osoite
    LDI ZH,lo8(data_siniaalto_end)           ; ole yli arrayn pituudesta.
    CP YL,ZL
    CPC YH,ZH
    BRNE isr_timer0_siniaalto_store
    LDI YL,lo8(data_siniaalto)               ; Looppaa takaisin array alkuun
    LDI YH,hi8(data_siniaalto)               ; jos oltaisiin liian pitkällä
isr_timer0_siniaalto_store:
    ST X,YH                                  ; Kirjoita seuraavan siniarvon
    ST -X,YL                                 ; osoite muistiin.
isr_timer0_siniaalto_timerit:
    OUT TCCR0B,REG_ZERO
    OUT TCNT0L,REG_ZERO
    OUT TCNT0H,REG_ZERO
    OUT OCR0AH,REG_ZERO
    OUT OCR0AL,REG_DATA1
    LDI ZH,(TIMER0_A_CS|TIMER0_B_SC)
    RET
