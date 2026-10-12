#define __SFR_OFFSET 0
#include <avr/io.h>
#include "isr_timer0.h"
#include "pinnit.h"
#include "rekisterit.h"
#include "data.h"

.global isr_timer0_ovf
.global isr_timer0_setup

.global data_lue_siniaalto

.section .text.isr.isr_timer0_ovf
isr_timer0_ovf:
    PUSH REG_DATA1
    RCALL data_lue_siniaalto
    OUT OCR0AL,REG_DATA1
    POP REG_DATA1
    RETI
