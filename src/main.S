#define __SFR_OFFSET 0
#include <avr/io.h>
#include "pinnit.h"
#include "rekisterit.h"

.global main
.global isr_reset


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
