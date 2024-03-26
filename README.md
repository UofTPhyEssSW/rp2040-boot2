# RP2040 BOOT2 : Stage 2 Bootloader development

This repository should be used as an example of how to develop boot stage 2 for the RP2040 with compatible Flash IC's 
using CMake. The main goal of this repository is to show how to develop the boot stage 2 bootloader. The SDK does 
provide many bootloader files for ease of use, but to learn how this is done takes time digging through documentation and 
the SDK file structure to understand how this is developed. This of course only becomes a problem if you want to use a 
flash IC that doesn't fit any of the files provided by this SDK or you want to develop your own stage 2 bootloader. So 
here you are. I hope what is provided here helps you on your engineering journey. Instructions are below.

## Development Software Prerequisites 
- <a href="https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads">Arm GNU toolchain</a> (≥ 13.2.Rel1) 
- <a href="https://cmake.org/download/">CMake</a> (≥ 3.24)
- <a href="https://ninja-build.org/">Ninja-build</a> (≥ 1.10.2)
- <a href="https://www.python.org/downloads/">Python</a> (≥ 3.10)

## Adding to this repository

This repository is setup for you to easily add to it and develop your bootloader. Use the following steps:

1. In the ./src folder create a folder with the part number of the flash IC you want to develop a bootloader for.
2. In that folder put all the files need for the bootloader.
3. Add the following line to the bottom of the ./src/CMakeLists.txt file: The dir_name is directory name that holds the
   bootloader files, and the file_list is a list of all bootloader files in the director seperated by a ;. 
```cmake
add_bootloader(<dir_name> <file_list> ${ASM_OUTPUT_DIR})
```
4. Run in the terminal of the os run the following command.

_Windows_
```shell
C:\..\rp2040-boot2> python ./asm_builder.py
```
_Linux_
```shell
~/../rp2040-boot2$ python3 ./asm_builder.py
```

## References

- <a href="https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf">RP2040 datasheet</a>
- <a href="https://www.winbond.com/hq/support/documentation/downloadV2022.jsp?__locale=en&xmlPath=/support/resources/.content/item/DA00-W25Q128JV.html&level=1">W25Q128JV datasheet</a>
- <a href="https://crascit.com/professional-cmake/">Professional CMake: A Practical Guide</a>
- <a href="https://github.com/raspberrypi/pico-sdk">Raspberry PI GitHub : PICO-SDK</a>
- <a href="https://www.raspberrypi.com/documentation/microcontrollers/rp2040.html">Raspberry PI, RP2040 documentation</a>
