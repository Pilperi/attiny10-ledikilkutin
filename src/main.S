#define __SFR_OFFSET 0
#include <avr/io.h>
#include "pinnit.h"
#include "reset.h"
#include "rekisterit.h"

.global main
.global isr_reset

.section .rodata
data_painallukset: .byte 1                   ; Pidetään SRAMissa kirjaa
                                             ; montako kertaa RESET on kutsuttu
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
isr_reset_init:                              ; Tallenna painallusmäärä SRAM
    LDI REG_TMP1,(N_PAINALLUSTA+1)
    STS data_painallukset,REG_TMP1
    RJMP main

.section .text.isr.isr_reset_via_pin
isr_reset_via_pin:                           ; Reset RESET-pinnillä
    LDI REG_TMP1,(1<<EXTRF)                  ; Nollaa pinniresettiflagi
    ANDI REG_TMP1,~(1<<EXTRF)
    OUT RSTFLR,REG_TMP1
isr_reset_lue_painallukset:
    LDS REG_ITER1,data_painallukset
    DEC REG_ITER1
    BREQ isr_reset_init                      ; Viimeisellä painalluksella reset
    STS data_painallukset,REG_ITER1
moodi_vilkuta:                               ; Vilkuta painallusten verran
    CBI PORTB,PIN_PUNA
    SBI PORTB,PIN_PUNA
    CBI PORTB,PIN_PUNA
    DEC REG_ITER1
    BRNE moodi_vilkuta
    CBI PORTB,PIN_SINI
    SBI PORTB,PIN_SINI
    CBI PORTB,PIN_SINI
    RJMP main

.section .text.main
main:
    CLI
main_init:
    LDI REG_TMP1,(1<<SE)
    OUT SMCR,REG_TMP1                        ; Sallii sleep
    CBI ACSR,ACIE                            ; Analog comp interrupt disable
    LDI REG_TMP1,(1<<ACD)
    OUT ACSR,REG_TMP1                        ; Analog comp disable
    LDI REG_TMP1,(1<<PRADC)
    OUT PRR,REG_TMP1                         ; Sulje ADC
    OUT DIDR0,REG_ZERO                       ; Sulje ADC digital input
main_loop:
    SEI
    SLEEP
    RJMP main_loop
