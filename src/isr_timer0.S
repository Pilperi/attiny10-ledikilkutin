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
    CLI
    PUSH ZL
    PUSH ZH
    PUSH REG_SCRATCH
    IN REG_SCRATCH,SREG
    PUSH REG_SCRATCH
    LDS ZL,(data_addr_rutiini)
    LDS ZH,(data_addr_rutiini + 1)
    ICALL
_isr_timer0_ovf_valmis:
    POP REG_SCRATCH
    OUT SREG,REG_SCRATCH
    POP REG_SCRATCH
    POP ZH
    POP ZL
    RETI
