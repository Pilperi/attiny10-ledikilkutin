#ifndef PINNIT_H
#define PINNIT_H
#include <avr/io.h>

#define PIN_PWM_A  PINB0
#define PIN_PWM_B  PINB1
#define PIN_INT0   PINB2
#define PIN_RESET  PINB3

#define PIN_NAPPI  PIN_INT0
#define PIN_ENABLE PINB2

#define PIN_LED_1       PINB0
#define PIN_LED_2       PINB1
#define PIN_MASK ((1<<PIN_LED_1)|(1<<PIN_LED_2)|(1<<PIN_ENABLE))

#endif // PINNIT_H
