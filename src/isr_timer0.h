#ifndef ISR_TIMER0_H
#define ISR_TIMER0_H

#include <avr/io.h>

#define TIMER0_CLK_0    ((0<<CS02)|(0<<CS01)|(0<<CS00))
#define TIMER0_CLK_1    ((0<<CS02)|(0<<CS01)|(1<<CS00))
#define TIMER0_CLK_8    ((0<<CS02)|(1<<CS01)|(0<<CS00))
#define TIMER0_CLK_64   ((0<<CS02)|(1<<CS01)|(1<<CS00))
#define TIMER0_CLK_254  ((1<<CS02)|(0<<CS01)|(0<<CS00))
#define TIMER0_CLK_1024 ((1<<CS02)|(0<<CS01)|(1<<CS00))
#define TIMER0_CLK_EXTF ((1<<CS02)|(1<<CS01)|(0<<CS00))
#define TIMER0_CLK_EXTR ((1<<CS02)|(1<<CS01)|(1<<CS00))

#define TIMER0_A_CS ((1<<COM0A1)|(0<<COM0A0))
#define TIMER0_A_SC ((1<<COM0A1)|(1<<COM0A0))
#define TIMER0_B_CS ((1<<COM0B1)|(0<<COM0B0))
#define TIMER0_B_SC ((1<<COM0B1)|(1<<COM0B0))

#endif // ISR_TIMER0_H