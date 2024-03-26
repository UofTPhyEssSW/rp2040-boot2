# Builds Project on Linux machine
import os
import subprocess as sub
import platform
import argparse

CMAKE_RUNTIME = 30  # CMake build timeout in seconds.
GENERATOR_TIMEOUT = 10  # Timeout for generator program.
BUILD_DIR = "output"


print(f"Running on ${sys_os} system")


def CMakeBuild(buildtype, generator, toolchain) -> int:
    '''Calls cmake to create build directory'''
    errorcode: int = 0

    try:
        ret = sub.run(["cmake",
                       f"--toolchain ${toolchain}",
                       f"-DCMAKE_BUILD_TYPE=${buildtype}",
                       f"-G ${generator}",
                       "."],
                      stdout=sub.PIPE, stderr=sub.PIPE,
                      timeout=CMAKE_RUNTIME)
    except Exception as ex:
        print("ERROR: ")
        errorcode = 1

    output = ret.stdout
    print(output)
    output = ret.stderr
    print(output)

    return errorcode


def Generator(sys_os, build_dir) -> int:
    errorcode: int = 0

    if sys_os == "Windows":
        try:
            ret = sub.run(["ninja", f"-C ${build_dir}", "-v"], stdout=sub.PIPE, stderr=sub.PIPE)
            errorcode = ret.returncode
        except Exception as ex:
            print("ERROR: Ninja failed.", str(ex))
            errorcode = 1

        if errorcode == 0:
            output = ret.stdout
            print(output)
        else:
            output = ret.stderr
            print(output)
    elif sys_os == "Linux":
        print("Linux Generator not implemented.")

    return errorcode


def main():

    sys_os = platform.system()

    ret = CMakeBuild('Debug', 'Ninja', 'tools/cmake/build_toolchain.cmake')

    ret = Generator(sys_os, "cmake-build")
    
    exit(0)
