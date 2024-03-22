cmake_minimum_required(VERSION 3.24)

add_bootloader(w25q128jv boot_stage2.s ${ASM_OUTPUT_DIR})
