cmake_minimum_required(VERSION 3.24)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

project(RP2040-BOOT2
        LANGUAGES ASM
        VERSION 0.1.0
        DESCRIPTION "Raspberry PI PICO Boot stage 2 repository."
)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 20)

set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/linker/rp2040_boot2.ld CACHE PATH "Linker script file path.")
set(ASM_OUTPUT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/output CACHE PATH "Generator Output directory.")
set(PYSCRIPT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tools/python CACHE PATH "Python script directory")

include(tools/cmake/boot2_builder.cmake)

add_subdirectory(src)
