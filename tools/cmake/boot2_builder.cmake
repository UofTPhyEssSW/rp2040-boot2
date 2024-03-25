
# Stage 2 Bootloader
function(add_bootloader SRC_DIR ASM_FILES OUTPUT_DIR)
    set(BL2_NAME bl2_${SRC_DIR})
    #compile assembly files
    add_executable(${BL2_NAME}.elf ${SRC_DIR}/${ASM_FILES})
    target_compile_options(${BL2_NAME}.elf PUBLIC ${ARCH_OPTIONS})
    target_link_options(${BL2_NAME}.elf PUBLIC
            ${ARCH_OPTIONS}
            -T ${LINKER_SCRIPT}
            -Wl,-Map=${OUTPUT_DIR}/map/${BL2_NAME}.map
            -nostdlib
    )
    # Convert .elf file to .bin
    add_custom_target(${BL2_NAME}_2bin
            ALL
            DEPENDS ${BL2_NAME}.elf
            COMMAND ${CMAKE_OBJCOPY} -O binary ${BL2_NAME}.elf ${OUTPUT_DIR}/bin/${BL2_NAME}.bin
            COMMENT " ${BL2_NAME}_2bin used to convert .elf to .bin"
    )
    # Convert .bin to .s
    add_custom_target(${BL2_NAME}_2asm
            ALL
            DEPENDS ${BL2_NAME}_2bin
            WORKING_DIRECTORY ${PYSCRIPT_DIR}
            COMMAND python ./bin2asm.py ${OUTPUT_DIR}/bin/${BL2_NAME}.bin ${OUTPUT_DIR}/asm/${BL2_NAME}.s
            COMMENT "${BL2_NAME}_2asm used to to converts .bin to .s file for as boot stage2 program for SDK."
    )

endfunction()
