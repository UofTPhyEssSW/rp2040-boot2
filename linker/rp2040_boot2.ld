/*
 * Flash Boot stage 2 linker script.
 */

MEMORY{
    /* 256byte SSI initialize code goes here, last 4 bytes are check sum.*/
    SRAM (rx) : ORIGIN = 0x20041F00, LENGTH = 252
}

SECTIONS{
/*    .= ORIGIN(SRAM);*/
    .text : {
        *(.entry)
        *(.text)
    } >SRAM
}
