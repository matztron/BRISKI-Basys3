/* Define memory regions */
MEMORY
{
    /* Define RAM and ROM memory regions with specific addresses and sizes */
      RAM (rwx) : ORIGIN = 0x00000400, LENGTH = 3072 
      ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 1024 
     /* RAM (rwx) : ORIGIN = 0x00000800, LENGTH = 2048 */
     /* ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 2048 */
     /* RAM (rwx) : ORIGIN = 0x00000600, LENGTH = 2560 */
     /* ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 1536 */
}

/* Define the sections and their placement */
SECTIONS
{
    /* Place the .text section in ROM */
    .text : {
        *(.text) /* All .text sections from input files */
    } >ROM

    /* Place the .data section in RAM */
    .data : {
        *(.data) /* All .data sections from input files */
    } >RAM

    /* BSS section */
    .bss :
    {
        *(.bss)
        *(.bss.*)
    } > RAM

    /* Additional sections can be added here */

/* Stack top */
    /* Set _stack_top to the highest valid RAM address (0x0FFF) */
    _stack_top = ORIGIN(RAM) + LENGTH(RAM) - 4;
}
