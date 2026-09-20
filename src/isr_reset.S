; Reset-handleri
;
; Kattaa eri reset-tapaukset:
; Virrat menee päälle:
;    Datan alustus ja hyppy main,
;    myös rekistereiden arvojen asetus
; RESET:
;    Tarkista monesko RESET on kyseessä,
;    hyppää vastaavaan funktioon
; Watchdog:
;    Ei katettu.

#define __SFR_OFFSET 0
#include <avr/io.h>
#include "isr_reset.h"
#include "init.h"
#include "pinnit.h"
#include "rekisterit.h"

.global main
.global isr_reset
.global data_painallukset

; Oletusrutiinit, korvaa oikeilla
.weak rutiini_nolla
.set rutiini_nolla,rutiini_nolla_default
.weak rutiini_1
.set rutiini_1,rutiini_1_default
.weak rutiini_2
.set rutiini_2,rutiini_2_default

.section .text.isr.isr_reset
isr_reset:                                   ; ISR virrat ylös tai RESET
    CLI
    LDI REG_ZERO,0x00
    LDI REG_MOLEMMAT,PIN_MOLEMMAT
    OUT DDRB,REG_MOLEMMAT
isr_reset_check_source:
    IN REG_TMP1,RSTFLR
    SBRS REG_TMP1,PORF                       ; Lue power-resetin flagi
    RJMP isr_reset_via_pin                   ; RESET-pinniä painettu
    RJMP isr_reset_via_power                 ; Virrat kytketty päälle

.section .text.isr.isr_reset_via_power
isr_reset_via_power:                         ; Reset kun virrat menee päälle
    LDI REG_TMP1,(1<<PORF)                   ; Nollaa poweriflagi
    ANDI REG_TMP1,~(1<<PORF)
    OUT RSTFLR,REG_TMP1
    RCALL init_data
    RJMP main

.section .text.isr.isr_reset_via_pin
isr_reset_via_pin:                           ; Reset RESET-pinnillä
    LDI REG_TMP1,(1<<EXTRF)                  ; Nollaa pinniresettiflagi
    ANDI REG_TMP1,~(1<<EXTRF)
    OUT RSTFLR,REG_TMP1
isr_reset_lue_painallukset:
    LDI XL,lo8(data_painallukset)
    LDI XH,hi8(data_painallukset)
    LD REG_ITER1,X
    DEC REG_ITER1
    BREQ rutiini_nolla                       ; Viimeisellä painalluksella reset
    ST X,REG_ITER1
isr_reset_hyppaa_rutiiniin:                  ; Hyppää oikeaan rutiiniin
    DEC REG_ITER1
    BREQ rutiini_1
    DEC REG_ITER1
    BREQ rutiini_2
    DEC REG_ITER1
    RJMP rutiini_nolla                       ; Oletuksena rutiini_nolla

.section .text.rutiinit_default
rutiini_nolla_default:
RJMP isr_reset_via_power
rutiini_1_default:
rutiini_2_default:
RJMP main
