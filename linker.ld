/* Linkerfile attiny10

Muistirakenne:
IO   0x0000...0x003F
SRAM 0x0040...0x005F
---  0x0060...0x3EFF
NVM  0x3F00...0x3F01
---  0x3F02...0x3F3F
CONF 0x3F40...0x3F41
---  0x3F42...0x3F7F
CAL  0x3F80...0x3F81
---  0x3F82...0x3FBF
ID   0x3FC0...0x3FC3
---  0x3FC4...0x3FFF
PMEM 0x4000...0x43FF
---  0x4400...0xFFFF
*/
start_pmem = 0x4000;
size_pmem = 1024;
start_sram = 0x0040;
size_sram = 32;
offset_sram = 0x00800000;


MEMORY
{
    /* Ohjelmamuisti ainoa johon voidaan kirjoittaa */
    program_memory : org = 0x0000, len = size_pmem
    /*
    SRAM hoidettu virtuaalisen offsetin kautta, laitteessa alkaa 0x0060.
    Vaikkei voida ohjelmoidessa kirjoittaa dataa, voidaan silti allokoida
    ja tarkistaa että mahtuuhan sinne mitä meinataan tuupata.
    Kaikki normaalit työkalut hoitaa homman niin että se on offsetilla
    0x800000 jolloin tiedetään että kyseessä on oma muistialueensa.
    Muille vastaaville hassumuisteille (EEPROM) on vastaavat offsetit.
     */
    sram : org = (offset_sram + start_sram), len = size_sram
}

SECTIONS
{
    /* Suoritettava koodi */
	. = ORIGIN(program_memory);
        .text : {
            KEEP(*.o(.isr_vector)); /* Koodin alussa interrupt-jumpit */
            *.o(.text.isr*);         /* Jumppien kohteet lähellä */
            *.o(.text.init*);        /* Init-rutiini lähellä */
            *.o(.text*);            /* Kaikki muu suoritettava koodi */
        } >program_memory
	/* Datalohko, kopioidaan SRAM puolelle */
    /* pmem_XXX_start_la : osoite program_memory-puolella */
    /* sram_XXX_start    : osoite SRAM-puolella */
        /* Vakiot */
        .rodata : {
            pmem_rodata_start_la = LOADADDR(.rodata)+start_pmem;
            sram_rodata_start = .;
	        *.o(.rodata);
            *.o(.rodata*);
            sram_rodata_end = .;
            } >sram AT >program_memory
        /* Alustetut muuttujat */
        .data : {
            pmem_data_start_la = LOADADDR(.data)+start_pmem;
	        sram_data_start = .;
            *.o(.data);
            *.o(.data*);
            sram_data_end = .;
            } >sram AT >program_memory
        /* Alustamattomat muuttujat, ei tarvita program_memory-osoitetta */
        .bss : {
	        sram_bss_start = .;
            *.o(.bss);
            *.o(.bss*);
            sram_bss_end = .;
            sram_bss_end_la = LOADADDR(.rodata)+ start_pmem + size_sram;
            } >sram
}
