#ifndef PINNIT_H
#define PINNIT_H

#include <avr/io.h>

#define PIN_PWM_A  PINB0
#define PIN_PWM_B  PINB1
#define PIN_INT0   PINB2
#define PIN_RESET  PINB3

#define PIN_NAPPI  PIN_INT0
#define PIN_ENABLE PINB2

#define PIN_PUNA       PINB0
#define PIN_SINI       PINB1
#define PIN_MOLEMMAT ((1<<PINB0)|(1<<PINB1))

#endif // PINNIT_H
