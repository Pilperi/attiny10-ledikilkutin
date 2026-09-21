; INIT-rutiini
;
; Alustaa dataosiot asianmukaisesti:
; .rodata esimääritellyt arvot paikalleen
; .bss pohjustamattomat muuttujat nollaan
;
; Olettaa että REG_ZERO on jo asetettu 0x00

#define __SFR_OFFSET 0
#include <avr/io.h>
#include "init.h"
#include "rekisterit.h"

.global init_data

.section .text.init.init_data
init_data:
    ; Sekä rodata ja data peräkanaa, joten
    ; voidaan kirjoittaa yhdessä pötkössä:
    ; aloitetaan rodata alusta
    ; ja lopetetaan data loppuun
    LDI ZL,lo8(pmem_rodata_start_la)         ; Lukuosoite
    LDI ZH,hi8(pmem_rodata_start_la)
    LDI YL,lo8(sram_rodata_start)            ; Kirjoitusosoite
    LDI YH,hi8(sram_rodata_start)
    LDI XL,lo8(sram_data_end)                ; Kirjoituksen lopetusosoite
    LDI XH,hi8(sram_data_end)
    RJMP init_data_siirto_loop_check
init_data_siirto_loop:
    LD REG_TMP1,Z+                           ; Lue FLASH Z:sta
    ST Y+,REG_TMP1                           ; Kirjoita SRAM Y:hyn
init_data_siirto_loop_check:                 ; Jatka kunnes Y==X
    CP YL,XL
    CPC YH,XH
    BRNE init_data_siirto_loop
    ; BSS heti data jälkeen, jatketaan
    ; samalla pointterilla BSS loppuun asti
init_data_sec_bss:                           ; Alustamaton (nollattu) data
    LDI XL,lo8(sram_bss_end_la)              ; Kirjoituksen lopetusosoite
    LDI XH,hi8(sram_bss_end_la)
    RJMP init_bss_fill_loop_check
init_bss_fill_loop:
    ST Y+,REG_ZERO                           ; Kirjoita SRAM 0x00
init_bss_fill_loop_check:
    CP YL,XL
    CPC YH,XH
    BRNE init_bss_fill_loop
    RET                                      ; init_data END
