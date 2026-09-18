#include "pinnit.h"
#include <avr/io.h>

void main(void)
{
    DDRB |= (1<<PIN_ENABLE);
    PORTB |= (1<<PIN_ENABLE);
    for(;;)
    {
        PINB = (1<<PIN_ENABLE);
    }
}
