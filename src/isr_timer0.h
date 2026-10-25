#ifndef TIMER0_H
#define TIMER0_H


#include <avr/io.h>

#define TIMER0_CLK_0    ((0<<CS02)|(0<<CS01)|(0<<CS00))
#define TIMER0_CLK_1    ((0<<CS02)|(0<<CS01)|(1<<CS00))
#define TIMER0_CLK_8    ((0<<CS02)|(1<<CS01)|(0<<CS00))
#define TIMER0_CLK_64   ((0<<CS02)|(1<<CS01)|(1<<CS00))
#define TIMER0_CLK_254  ((1<<CS02)|(0<<CS01)|(0<<CS00))
#define TIMER0_CLK_1024 ((1<<CS02)|(0<<CS01)|(1<<CS00))
#define TIMER0_CLK_EXTF ((1<<CS02)|(1<<CS01)|(0<<CS00))
#define TIMER0_CLK_EXTR ((1<<CS02)|(1<<CS01)|(1<<CS00))

// Pinnien toimintamoodit:
// 00 : ei kyketty
// 01 : ei kytketty
// 10 : clear ylös mennessä, set alas mennessä (CS)
// 11 : set ylös mennessä, clear alas mennessä (SC)
#define TIMER0_A_NC ((0<<COM0A1)|(0<<COM0A0))
#define TIMER0_A_01 ((0<<COM0A1)|(1<<COM0A0))
#define TIMER0_A_CS ((1<<COM0A1)|(0<<COM0A0))
#define TIMER0_A_SC ((1<<COM0A1)|(1<<COM0A0))
#define TIMER0_B_NC ((0<<COM0B1)|(0<<COM0B0))
#define TIMER0_B_01 ((0<<COM0B1)|(1<<COM0B0))
#define TIMER0_B_CS ((1<<COM0B1)|(0<<COM0B0))
#define TIMER0_B_SC ((1<<COM0B1)|(1<<COM0B0))

#define TIMER0_WGM_MODE_NORMAL   0b0000
#define TIMER0_WGM_MODE_PWM_PC8  0b0001
#define TIMER0_WGM_MODE_PWM_PC9  0b0010
#define TIMER0_WGM_MODE_PWM_PC10 0b0011

// Rutiinien kesken jaetut arvot
#define TIMER0_WGM       (TIMER0_WGM_MODE_PWM_PC8)
#define TIMER0_WGM_A     ((0b0011 & TIMER0_WGM)<<WGM00)
#define TIMER0_WGM_B     ((0b1100 & TIMER0_WGM)<<WGM02)
#define TIMER0_MODE_ICN   0
#define TIMER0_MODE_ICES  0
#define TIMER0_CS_FAST   (TIMER0_CLK_8)
#define TIMER0_CS_SLOW   (TIMER0_CLK_1024)
#define TIMER0_VAL_TCNT    0x0000

// Rutiinin 1 arvot:
// OCR ei väliä, luetaan taulukosta
// TIMSK pelkkä overflow
// Sekä A että B set -> clear
// 8 bit PWM (phase correct)
#define TIMER0_AALTO_MOLEMPI_OCR    100
#define TIMER0_AALTO_MOLEMPI_TIMSK  (1<<TOIE0)
#define TIMER0_AALTO_MOLEMPI_TCCR0A (TIMER0_A_SC|TIMER0_B_SC|TIMER0_WGM_A)
#define TIMER0_AALTO_MOLEMPI_TCCR0B (TIMER0_MODE_ICN|TIMER0_MODE_ICES|TIMER0_WGM_B|TIMER0_CS_FAST)
#define TIMER0_AALTO_TAAJUUS 50

// Rutiinin 2 arvot:
// OCR 100
// TIMSK pelkkä overflow
// A set -> clear, B not connected
// 8 bit PWM (phase correct)
#define TIMER0_SININEN_OCR    100
#define TIMER0_SININEN_TIMSK  (1<<TOIE0)
#define TIMER0_SININEN_TCCR0A (TIMER0_A_SC|TIMER0_B_NC|TIMER0_WGM_A)
#define TIMER0_SININEN_TCCR0B (TIMER0_MODE_ICN|TIMER0_MODE_ICES|TIMER0_WGM_B|TIMER0_CS_FAST)

// Rutiinin 3 arvot:
// OCR 100
// TIMSK pelkkä overflow
// A not connected, B set -> clear
// 8 bit PWM (phase correct)
#define TIMER0_VALKOINEN_OCR    250
#define TIMER0_VALKOINEN_TIMSK  (1<<TOIE0)
#define TIMER0_VALKOINEN_TCCR0A (TIMER0_A_NC|TIMER0_B_SC|TIMER0_WGM_A)
#define TIMER0_VALKOINEN_TCCR0B (TIMER0_MODE_ICN|TIMER0_MODE_ICES|TIMER0_WGM_B|TIMER0_CS_FAST)



#endif //TIMER0_H
