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
#include "rutiinit.h"

.global main
.global isr_reset
.global data_painallukset
.global isr_reset_via_power_init
.global rutiini_1_alustus
.global rutiini_2_alustus
.global rutiini_3_alustus
.global rutiini_4_alustus
.global rutiini_nolla


.section .text.isr.isr_reset
isr_reset:                                   ; ISR virrat ylös tai RESET
    CLI
    LDI REG_ZERO,0x00
    LDI REG_TMP1,PIN_MASK
    OUT DDRB,REG_TMP1                        ; Kaikki ulostuloja
    LDI REG_TMP1,(1<<SE)                     ; Sallitaan sleep
    OUT SMCR,REG_TMP1
isr_reset_check_source:
    IN REG_TMP1,RSTFLR
    SBRS REG_TMP1,PORF                       ; Lue power-resetin flagi
    RJMP isr_reset_via_pin                   ; RESET-pinniä painettu
    RJMP isr_reset_via_power                 ; Virrat kytketty päälle

; Reset kun virrat menee päälle
.section .text.isr.isr_reset_via_power
isr_reset_via_power:
    LDI REG_TMP1,(1<<PORF)                   ; Nollaa poweriflagi
    ANDI REG_TMP1,~(1<<PORF)
    OUT RSTFLR,REG_TMP1
isr_reset_via_power_init:
    SBI PORTB,PIN_ENABLE                     ; Enable ylös
    SBI DDRB,PIN_ENABLE
    RCALL init_data                          ; Kirjoita datat SRAM:iin
    BREQ rutiini_4_alustus                   ; Aloitetaan ykkösrutiinilla
    RJMP main

; Reset kun RESET-pinni on mennyt alas
.section .text.isr.isr_reset_via_pin
isr_reset_via_pin:
    SBI PORTB,PIN_ENABLE
    LDI REG_TMP1,(1<<EXTRF)                  ; Nollaa pinniresettiflagi
    ANDI REG_TMP1,~(1<<EXTRF)
    OUT RSTFLR,REG_TMP1
isr_reset_lue_painallukset:                  ; Katso mihin rutiiniin mennään
    LDS REG_ITER1,data_painallukset
    DEC REG_ITER1
    BREQ isr_reset_hyppaa_rutiiniin_default  ; Viimeisellä painalluksella virrat
    STS data_painallukset,REG_ITER1          ; Muutoin tallennetaan uusi arvo
isr_reset_hyppaa_rutiiniin:                  ; ja hypätään rutiinin alustukseen
    DEC REG_ITER1
    BREQ rutiini_1_alustus
    DEC REG_ITER1
    BREQ rutiini_2_alustus
    DEC REG_ITER1
    BREQ rutiini_3_alustus
    DEC REG_ITER1
    BREQ rutiini_4_alustus
isr_reset_hyppaa_rutiiniin_default:
    RJMP rutiini_nolla                       ; Oletuksena rutiini_nolla
