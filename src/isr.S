/*
;===============================================================================
; ISR attiny10
;===============================================================================
*/
#define __SFR_OFFSET 0
#include <avr/io.h>

; Handlerit
; .weak heikolle määritykselle ja .set oletusarvolle
; Ylikirjoitettavissa niin että jossain muualla on olemassa
; samanniminen funktio joka ei ole "weak"

.weak isr_reset
.weak isr_int0
.weak isr_pcint0
.weak isr_timer0_ovf
.weak isr_ana_comp
.weak isr_timer0_compa
.weak isr_timer0_compb
.weak isr_wdt
.weak isr_vlm
.weak isr_adc
.set isr_reset,isr_default_reset
.set isr_int0,isr_default
.set isr_pcint0,isr_default
.set isr_timer0_capt,isr_default
.set isr_timer0_ovf,isr_default
.set isr_ana_comp,isr_default
.set isr_timer0_compa,isr_default
.set isr_timer0_compb,isr_default
.set isr_wdt,isr_default
.set isr_vlm,isr_default
.set isr_adc,isr_default

; main mieluiten jossain C-puolella, mutta varuiksi defaultti
.weak main
.set main,isr_default_main

; Datan alustusrutiinit
.weak init_data
.set init_data,isr_default_init_data

;===============================================================================
.section .isr_vector
.org 0x0000
; Interrupt vector
; Hypätään interruptista vastaavaan rutiiniin
rjmp isr_reset        ; RESET
rjmp isr_int0         ; INT0
rjmp isr_pcint0       ; PCINT0
rjmp isr_timer0_capt  ; TIM0_CAPT
rjmp isr_timer0_ovf   ; TIM0_OVF
rjmp isr_timer0_compa ; TIM0_COMPA
rjmp isr_timer0_compb ; TIM0_COMPB
rjmp isr_ana_comp     ; ANA_COMP
rjmp isr_wdt          ; WDT
rjmp isr_vlm          ; VLM
rjmp isr_adc          ; ADC

;===============================================================================
.section .text.isr

; Oletusreset
; Aseta R1 nollaksi (aina nolla)
; Aseta stack pointer järkevään osoitteeseen (muistin loppupääty)
; Hyppää main
.section .text.isr.isr_default_reset
isr_default_reset:
    LDI	R26,lo8(RAMEND)
	OUT	SPL,R26
	LDI	R26,hi8(RAMEND)
	OUT	SPH,R26
    RCALL init_data
    RJMP main

; Oletushandleri, pelkkä rjmp + reti
.section .text.isr.isr_default
isr_default:
    reti

;===============================================================================
.section .text
; Varuiksi oletus-main (ikuinen loop)
.section .text.isr_default_main
isr_default_main:
    RJMP isr_default_main

.section .text.init
.section .text.init.isr_default_init_data
isr_default_init_data:
    RET
