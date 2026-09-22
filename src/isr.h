#ifndef ISR_H
#define ISR_H

#ifndef __ASSEMBLER__

/* RESET: virrat päälle tai pinni alas */
void isr_reset(void);

/* INT0-pinni (PINB2) */
void isr_int0(void);

/* PCINT-interruptit (jaettu) */
void isr_pcint0(void);

/* timer0 input capture */
void isr_timer0_capt(void);

/* timer0 overflow */
void isr_timer0_ovf(void);

/* timer0 compare A match */
void isr_timer0_compa(void);

/* timer0 compare B match */
void isr_timer0_compb(void);

/* Analog comparator */
void isr_ana_comp(void);

/* Watchdog timer */
void isr_wdt(void);

/* Voltage level monitor */
void isr_vlm(void);

/* Analog digital conversion */
void isr_adc(void);

#endif // __ASSEMBLER__
#endif // ISR_H
