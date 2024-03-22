//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// file: boot_stage2.s
// date: 2024-02-
// author: Robert Morley (robert.morley@utoronto.ca)
//
// brief: Boot Stage 2 asm file for initializing SSI peripheral and FLASH IC for XIP mode.
//
// version: v0.1.0
// copyright (c) 2024
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.global _boot_stage2
.section .text
.syntax unified
.thumb

// Application Constants
.equ APPLICATION_START,                 0x10000100
.equ VTOR_ADDRESS,                      0xE000ED08
// SSI Register address/offset
.equ SSI_BASE_ADDR,                     0x18000000
.equ SSI_CTRL0_OFST,                    0x00
.equ SSI_CTRL1_OFST,                    0x04
.equ SSI_SSIENR_OFST,                   0x08
.equ SSI_BAUDR_OFST,                    0x14
.equ SSI_SR_OFST,                       0x28
.equ SSI_DR0_OFST,                      0x60
.equ SSI_RX_SAMPLE_DELAY_OFST,          0xF0        /* Consider signed value will not work for #imm */
.equ SSI_SPI_CTRLR0_OFST,               0xF4
// SSI Settings
.equ SSI_SCLK_DIV,                      0x4
// PAD Control Registers - QSPI address/offset
.equ PAD_QSPI_BANK_BASE,                0x40020000
.equ PAD_QSPI_IO_SETTING,               0x60
.equ PAD_QSPI_SCLK_OFST,                0x04
.equ PAD_QSPI_SD0_OFST,                 0x08
.equ PAD_QSPI_SD1_OFST,                 0x0C
.equ PAD_QSPI_SD2_OFST,                 0x10
.equ PAD_QSPI_SD3_OFST,                 0x14
// QSPI Settings
.equ QSPI_SCLK_SETTING,                 0x00000064      /* Sets SCLK drive strength to 8mA, Schmitt trigger disabled. */
.equ PAD_QSPI_SCHMITT_BIT,              0x02
// Flash Constants (W25Q128JV)
.equ W25Q128JV_WAIT_CYCLES,             0x00000004      /* 4 SCLK wait cycles between address and data phase for QSPI */
.equ W25Q128JV_CTRL0_SPI_FMT,           0x00070000      /* CTRLR0 : Standard SPI protocol, 8bit data frame, and TX/RX transfer mode. */

.equ W25Q128JV_CTRL0_XIP,               0x00270300      /* CTRLR0 : Quad IO SPI protocol, 32bit : 8 sclk data frame, EEPROM Read transfer mode. */
.equ W25Q128JV_SPI_CTRL0_XIP_ENTER,     0xA0000C21      /* SPI_CTRLR0 : Transfer type : SPI cmd, QSPI addr/data; Addr length = 24bits, Instruction length = 0, Wait cycles = 4, XIP command = 0xA0 */
.equ W25Q128JV_SPI_CTRL0_XIP_CONT,      0xA0000C21      /* SPI_CTRLR0 : Transfer type : SPI cmd, QSPI addr/data; Addr length = 24bits, Instruction length = 0, Wait cycles = 4, XIP command = 0xA0 */

// Flash Commands (W25Q128JV)
.equ W25Q128JV_QSPI_READ_CMD,           0xEB            /* Fast Read Quad IO command (24bit addr, 1 0xFx, 2 Dummy) */
.equ W25Q128JV_QFAST_OUT_CMD,           0x6B            /* Fast Read Quad Output command (24bit addr, 4 dummy) --NOT USED-- */
.equ W25Q128JV_RD_STATUS_REG1,          0x05            /* Read Status Register 1 command */
.equ W25Q128JV_RD_STATUS_REG2,          0x35            /* Read Status Register 2 command */
.equ W25Q128JV_RD_STATUS_REG3,          0x15            /* Read Status Register 3 command */
.equ W25Q128JV_WR_STATUS_REG1,          0x01            /* Write Status Register 1 command */
.equ W25Q128JV_WR_STATUS_REG2,          0x31            /* Write Status Register 2 command */
.equ W25Q128JV_WR_STATUS_REG3,          0x11            /* Write Status Register 3 command */
.equ W25Q128JV_CONTINUOUS_MODE,         0xA0
// R3 : Holds SSI Base address
// R1 : Holds Variable value
_boot_stage2: // Entry point
    push {lr}
config_qspi_io:
    ldr  r3, =PAD_QSPI_BANK_BASE
    movs r0, #QSPI_SCLK_SETTING                     /* Load QSPI SCLK IO Settings, Driver strength = 8mA */
    str  r0, [r3, #PAD_QSPI_SCLK_OFST]              /* Store SCLK IO setting in PAD_QSPI_SCLK_REGISTER */
    /* movs r0, #PAD_QSPI_IO_SETTING                   /* Disable Schmitt trigger and keep all other reset vales. */

    movs r1, #PAD_QSPI_SCHMITT_BIT                  /* Move Schmitt trigger enable bit offset into R1 */
    bics r0, r1                                     /* Clear Schmitt trigger bit */

    str  r0, [r3, #PAD_QSPI_SD0_OFST]               /* Disable schmitt trigger input for each SDx IO (bit 1)*/
    str  r0, [r3, #PAD_QSPI_SD1_OFST]
    str  r0, [r3, #PAD_QSPI_SD2_OFST]
    str  r0, [r3, #PAD_QSPI_SD3_OFST]
config_ssi:
    ldr  r3, =SSI_BASE_ADDR
    movs r1, #0
    str  r1, [r3, #SSI_SSIENR_OFST]                 /* Disable SSI peripheral */
    movs r1, #SSI_SCLK_DIV
    str  r1, [r3, #SSI_BAUDR_OFST]                  /* Set QSPI_SCLK divider */
    movs r1, #1
    ldr  r2, =SSI_RX_SAMPLE_DELAY_OFST
    str  r1, [r3, r2]                               /* Set input delay to 1 clk cycle */
config_xip:
    ldr  r1, =W25Q128JV_CTRL0_SPI_FMT               /* Set SPI protocol to Standard for status read. */
    str  r2, [r3, #SSI_CTRL0_OFST]
    movs r1, #1                                     /* Enable SSI peripheral */
    str  r1, [r3, #SSI_SSIENR_OFST]
    movs r0, #W25Q128JV_RD_STATUS_REG2              /* Read Status Register 2 */
    bl   read_flash_sreg
    cmp  r0, #0x02                                  /* Check is QSPI is enabled. */
    beq  qspi_mode_enabled                          /* If QSPI mode is enabled skip not steps. */
    movs r1, #W25Q128JV_WR_STATUS_REG2              /* Write Status Register 2 to enable QSPI mode. */
    str  r1, [r3, #SSI_DR0_OFST]                    /* Transmit instruction. */
    movs r0, #0                                     /* Set dummy byte to 0 */
    str  r1, [r3, #SSI_DR0_OFST]                    /* Transmit Dummy byte. */
    str  r1, [r3, #SSI_DR0_OFST]                    /* Transmit Dummy byte. */
    bl   wait_for_ssi_ready
    ldr  r1, [r3, #SSI_DR0_OFST]                    /* Read data for flash */
    ldr  r1, [r3, #SSI_DR0_OFST]
    ldr  r1, [r3, #SSI_DR0_OFST]
flash_ic_busy:
    movs r0, #W25Q128JV_RD_STATUS_REG1              /* Read status register 0, check for busy bit */
    bl read_flash_sreg
    movs r1, #1
    tst  r0, r1
    bne  flash_ic_busy                              /* If flash ic is busy continue loop until it's not. */
qspi_mode_enabled:
    movs r1, #0
    str  r1, [r3, #SSI_SSIENR_OFST]                 /* Disable SSI peripheral */
    ldr  r1, =W25Q128JV_CTRL0_XIP
    str  r1, [r3, #SSI_CTRL0_OFST]                  /* Set SSI to Quad SPI protocol and transfer mode to EEPROM read */
    movs r1, #0
    str  r1, [r3, #SSI_CTRL1_OFST]                  /* Set NDF to 0 for 1, 32bit read */
    ldr  r1, =W25Q128JV_SPI_CTRL0_XIP_ENTER
    ldr  r2, =SSI_SPI_CTRLR0_OFST
    str  r1, [r3, r2]                               /* Quad IO, 8bit instruction, 32bit address, EEPROM read transfer mode. */
    movs r1, #1
    str  r1, [r3, #SSI_SSIENR_OFST]                 /* Reenable SSI peripheral */
    /* First command to FLASH to start continuous mode */
    ldr  r1, =W25Q128JV_QSPI_READ_CMD
    str  r1, [r3, #SSI_DR0_OFST]                    /* Send Fast Read Quad IO command to TX FIFO */
    ldr  r1, =W25Q128JV_CONTINUOUS_MODE
    str  r1, [r3, #SSI_DR0_OFST]                    /* send address and continuous mode to TX FIFO, transfer begins here. */
    bl   wait_for_ssi_ready                         /* Wait for transfer to finish. */
    movs r1, #0
    str  r1, [r3, #SSI_SSIENR_OFST]                 /* Disable SSI peripheral */
    /* Setup SSI to keep flash in continous mode. */
    ldr  r1, =W25Q128JV_SPI_CTRL0_XIP_CONT
    ldr  r2, =SSI_SPI_CTRLR0_OFST
    str  r1, [r3, r2]
    movs r1, #1
    str  r1, [r3, #SSI_SSIENR_OFST]                 /* Reenable SSI peripheral, FLASH and SSI now in XIP mode. */
exit_from_boot2:
    pop    {r0}                                     /* Get Linker address from begining of boot_stage2 */
    movs   r1, #0
    cmp    r0, r1                                   /* Check if address is 0x00000000 */
    beq    app_entry                                /* If not returning from call initialize stack and VTOR for application entry */
    bx     r0                                       /* Return from call. */
app_entry:
    ldr    r0, =(APPLICATION_START)                 /* Get starting address of application */
    ldr    r1, =(VTOR_ADDRESS)                      /* Get Vector Table Offset Register Address */
    str    r0, [r1]                                 /* Load starting address of program in VTOR. */
    ldmia  r0, {r0, r1}
    msr    msp, r0                                  /* Initialize Stack pointer */
    bx     r1                                       /* Call application Reset_Handler, no link */

.global wait_for_ssi_ready
.type wait_for_ssi_ready,%function
.thumb_func
/* r3 [arg3] = SSI Base address */
wait_for_ssi_ready:
    push { r0, r1, lr } /* Preserve R0, R1, LR. */
tx_fifo_not_empty:
    ldr  r1, [r3, #SSI_SR_OFST]     /* Read SSI status register. */
    movs r0, #4
    tst  r1, r0                     /* Checks if TX FIFO empty bit is set */
    beq  tx_fifo_not_empty          /* loop if TX FIFO empty bit is not set */
    movs r0, #1
    tst r1, r0                      /* Check if BUSY flag is set. */
    bne tx_fifo_not_empty           /* loop if BUSY flag is set. */
    pop { r0, r1, pc }              /* Return from call. */

.global read_flash_sreg
.type read_flash_sreg,%function
.thumb_func
/* SSI Peripheal transfer mode must be TX/RX for this function to operate properly. */
/* r0 [arg0] = Instruction OP-CODE; and return value */
/* r1 [arg1] = NOT USED (POPPED)*/
/* r2 [arg2] = Number of dummy writes (NOT IMPLEMENTED YET)*/
/* r3 [arg3] = SSI Base address */
read_flash_sreg:
    push { r1, lr }                     /* Preserve R1 and LR */
    str  r0, [r3, #SSI_DR0_OFST]        /* Send Instruction Op-code */
    str  r0, [r3, #SSI_DR0_OFST]        /* Send Dummy byte to get RX data */
    bl   wait_for_ssi_ready             /* */
    ldr  r0, [r3, #SSI_DR0_OFST]        /* Discard first byte. */
    ldr  r0, [r3, #SSI_DR0_OFST]        /* This is the status word returned. */
    pop  { r1, pc }
