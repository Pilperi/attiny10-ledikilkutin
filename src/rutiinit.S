; Toimintamoodit/rutiinit
;
; Kullakin rutiinilla on alustusfunktio ja kaverina suoritettava funktio.
; Alustusfunktio pistää parametrit kohdilleen ja kirjaa
; suoritettavan funktion osoitteen SRAM:iin oikealle kohdalle.
;
; Pinnit on pistetty oikeaan asentoon jo init-puolella.
;
; Eri tilat joihin laite menee resetillä:
; Rutiini 0:
;    Katkaise virrat (viimeinen tila)
; Rutiini 1:
;    Aaltoileva sininen-valkoinen
; Rutiini 2:
;    Himmeä sininen
; Rutiini 3:
;    Himmeä valkoinen
; Rutiini 4:
;    Täydet tehot valkoisella (ensimmäinen tila)


#define __SFR_OFFSET 0
#include <avr/io.h>
#include "rutiinit.h"
#include "pinnit.h"
#include "rekisterit.h"
#include "isr_timer0.h"
#include "data.h"

.global rutiini_nolla
.global rutiini_1_alustus
.global rutiini_1
.global rutiini_2_alustus
.global rutiini_2
.global rutiini_3_alustus
.global rutiini_3
.global rutiini_4_alustus
.global rutiini_4


;###############################################################################
; Rutiinien alustusfunktiot

; Rutiini 4: täydet tehot valkoisella, ei kelloja tmv
.section .text.rutiinit.rutiini_4_alustus
rutiini_4_alustus:
    SBI PORTB,PIN_LED_2
    LDI XL,fpointer_lo(rutiini_4)
    LDI XH,fpointer_hi(rutiini_4)
    RJMP rutiini_common

.section .text.rutiinit.rutiini_3_alustus
; Rutiini 3: Himmeät tehot valkoisella
;.section .text.rutiinit.rutiini_3_alustus
rutiini_3_alustus:
    LDI REG_DATA1,TIMER0_VALKOINEN_OCR
    LDI REG_DATA2,TIMER0_VALKOINEN_TIMSK
    LDI REG_DATA3,TIMER0_VALKOINEN_TCCR0A
    LDI REG_DATA4,TIMER0_VALKOINEN_TCCR0B
    RCALL aseta_kello
    LDI XL,fpointer_lo(rutiini_3)
    LDI XH,fpointer_hi(rutiini_3)
    RJMP rutiini_common

; Rutiini 2: Himmeät tehot sinisellä
.section .text.rutiinit.rutiini_2_alustus
rutiini_2_alustus:
    LDI REG_DATA1,TIMER0_SININEN_OCR
    LDI REG_DATA2,TIMER0_SININEN_TIMSK
    LDI REG_DATA3,TIMER0_SININEN_TCCR0A
    LDI REG_DATA4,TIMER0_SININEN_TCCR0B
    RCALL aseta_kello
    LDI XL,fpointer_lo(rutiini_2)
    LDI XH,fpointer_hi(rutiini_2)
    RJMP rutiini_common

; Rutiini 1: Aaltoilevat tehot valkoisella ja sinisellä
.section .text.rutiinit.rutiini_1_alustus
rutiini_1_alustus:
    LDI REG_TAAJUUS,TIMER0_AALTO_TAAJUUS
    STS (data_taajuus),REG_TAAJUUS
    LDI REG_DATA1,TIMER0_AALTO_MOLEMPI_OCR
    LDI REG_DATA2,TIMER0_AALTO_MOLEMPI_TIMSK
    LDI REG_DATA3,TIMER0_AALTO_MOLEMPI_TCCR0A
    LDI REG_DATA4,TIMER0_AALTO_MOLEMPI_TCCR0B
    RCALL aseta_kello
    LDI XL,fpointer_lo(rutiini_1)
    LDI XH,fpointer_hi(rutiini_1)
    RJMP rutiini_common


; Yhteinen osa rutiineille: asetetaan kutsupointterin arvo SRAM ja hypätään main
.section .text.rutiinit.rutiini_common
rutiini_common:
    STS (data_addr_rutiini),XL
    STS (data_addr_rutiini + 1),XH
    RJMP main

;###############################################################################
; Itse rutiinit

; Rutiineilla 2,3,4 pelkkä paluukutsu rutiinina, ei tehdä mitään ihmeellistä
.section .text.rutiinit
rutiini_4:
rutiini_3:
rutiini_2:
    RET

; Rutiinilla 1 luetaan siniarvotaulukosta seuraava arvo
rutiini_1:
    DEC REG_TAAJUUS
    BRNE rutiini_1_valmis
    LDI REG_TAAJUUS,TIMER0_AALTO_TAAJUUS     ; Laskuri takaisin
    RCALL seuraava_siniarvo
    OUT OCR0AL,REG_DATA1
    COM REG_DATA1
    OUT OCR0BL,REG_DATA1
rutiini_1_valmis:
    RET

; Rutiini 0: Enable-pinni alas, sammutetaan virrat.
rutiini_nolla:
    CBI PORTB,PIN_ENABLE                     ; Enable alas ja
rutiini_nolla_loop:                          ; ikuinen loop rullaamaan
    SLEEP
    RJMP rutiini_nolla_loop

; Aseta timer0 asetukset
.section .text.rutiinit.aseta_kello
aseta_kello:
    OUT TCCR0B,REG_ZERO
    OUT TCNT0H,REG_ZERO
    OUT TCNT0L,REG_ZERO

    OUT OCR0AH,REG_ZERO
    OUT OCR0AL,REG_DATA1
    OUT OCR0BL,REG_DATA1

    OUT TCCR0A,REG_DATA3
    OUT TCCR0B,REG_DATA4
    LDI REG_SCRATCH,0xFF
    OUT TIFR0,REG_SCRATCH
    OUT TIMSK0,REG_DATA2
    RET
