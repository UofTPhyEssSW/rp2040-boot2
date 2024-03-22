# RP2040-BOOT2 repository (still under development)

Raspberry-PI Boot Stage 2 loader repository for custom implementations.

This repository should be used as an example on how to develop boot stage 2 for the RP2040 and compatible 
Flash IC's with CMake. 

The RP2040 has first stage bootloader that loads the second stage bootloader. When the first stage
board loader loads the second stage bootloader (256bytes) into RAM and then runs a checksum on the data. If the checksum
passes the second stage bootloader starts. If the checksum fails the first stage bootloader increments the CPOL, CPHA 
settings and tries again. If this continues to fail for more than 0.5s the RP2040 enters USB device mode and any program
on the flash chip is ignored (Refer to RP2040 datasheet, figure 15, pg132). 

## Development Steps

1. Code an .s assembly file that initializes the XIP peripheral and external Flash IC. The flash IC must be 
   set into continuous read mode for the RP2040 to execute code from the flash. The code size cannot exceed
   252bytes or the bootloader will not work. 
2. Compile the .s file into .elf file using ARM GNU GCC. The compiler uses a bare bones linker script only for
   the bootloader don't use to for application development for the RP2040. The compiler will fill if the .s code
   is larger than 252bytes.
3. Once compiled the .elf file must be converted into a .bin file. This step is needed so the code can be converted
   into .s for development of an RP2040 application.
4. To convert the .bin file into .s file for development use the bin2asm.py script in the ./tools/python/ directory

If you have managed to go through the steps you have a boot stage 2 program ready for testing in an RP2040 application.
These steps are the way to manual compile, link and convert the boot stage 2 program into an .s assembly file. The next section
you can use CMake to automate the above steps.

## Using CMake for development 

If you have never used CMake before I suggest using <a href="https://cmake.org/cmake/help/latest/">CMake Reference documentation</a> 
and going to YouTube to watch some tutorials before going forward. That being said you don't have to a CMake expert to understood 
how this project is implemented. Here is a breakdown of the CMake files in the repository:

- ./CMakeLists.txt : Root CMake file used to declare the projects, include files, constant variables, and subdirectories.
- ./tools/cmake/tool_chain.cmake : This file defines the compiler and compiler options used in the repository.
- ./tools/cmake/boot2_builder.cmake : This file defines the **_add_bootloader_** function using the CMake to generator the 
  .elf, .bin, and .s files necessary to compile the boot stage 2 bootloader.
- ./src/CMakeLists.txt : This file is call by the ./CMakeLists.txt file as a subdirectory. This file contains all custom
  boot stage 2 program implementation commands.

The _add_bootloader_ function is used to add a new boot stage 2 executable to the project easily. The _add_bootloader_ 
function has 3 parameters, SRC_DIR, ASM_FILES, and OUTPUT_DIR. SRC_DIR is for the source directory of the bootloader, 
ASM_FILES and the names on any files used to develop the bootloader, and OUTPUT_DIR is the output directory you want 
the new .s assembly in. For example, the directory ./src/w25q128jv holds the bootloader code for the Winbond W25Q128JV 
QSPI flash IC. To create an executable for this bootloader use the _add_bootloader_ function at the end of the ./src/CMakeLists.txt
file as follows:

```cmake
add_bootloader(w25q128jv boot_stage2.s ${OUTPUT_DIR})
```

Once you have add this line CMake will create an executable and 2 custom targets for this bootloader. There names are 
derived from the parameters provide to the function. For example the .elf for will be bl2_w25q128jv.elf. The name of the 
file will carry all the way down to the new .s file which will be in this case bl2_w25q128jv.s. The OUTPUT_DIR variable
is set in the root CMakeList.txt file, as ./output. Each file created has directory in the output directory of the 
repository. 

## Referenceces

- <a href="https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf">RP2040 datasheet</a>
- <a href="https://www.winbond.com/hq/support/documentation/downloadV2022.jsp?__locale=en&xmlPath=/support/resources/.content/item/DA00-W25Q128JV.html&level=1">W25Q128JV datasheet</a>
- <a href="https://crascit.com/professional-cmake/">Professional CMake: A Practical Guide</a>
