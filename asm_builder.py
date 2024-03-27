# Builds Project RP2040-Boot2 project
#
# prerequisite:
#   - Arm GNU Toolchain (≥ 13.2.Rel1)
#   - Python
#   - Ninja-build
# Optional
#   - Docker
#
import os
import subprocess as sub
import shutil

# Project constants
BUILD_DIR = "cmake-build-bl2"  # Build output directory
BUILD_TYPE = "Debug"  # Build type
BUILD_GENERATOR = "Ninja"  # Generator program name
ASM_TOOL_CHAIN = "tools/cmake/tool_chain.cmake"  # Toolchain file (do not modify)
CMAKE_TIMEOUT = 30  # CMake build timeout in seconds.
GENERATOR_TIMEOUT = 10  # Timeout for generator program.

CURRENT_DIR = os.getcwd()


def CMakeBuild(build_dir, buildtype, generator, toolchain) -> int:
    '''Calls cmake to create build directory'''
    errorcode: int = 0
    print("Starting CMake ...")
    print(f"\t--Output Directory : {build_dir}")
    print(f"\t--Type : {buildtype}")
    print(f"\t--Generator : {generator}")
    print(f"\t--Tool chain file : {toolchain}\n")

    try:
        ret = sub.run(["cmake",
                       f"-B {build_dir}",
                       f"--toolchain {toolchain}",
                       f"-DCMAKE_BUILD_TYPE={buildtype}",
                       f"-G {generator}",
                       "."],
                      stdout=sub.PIPE, stderr=sub.PIPE,
                      timeout=CMAKE_TIMEOUT)
    except Exception as ex:
        print("ERROR: ")
        errorcode = 1

    if ret.returncode == 0:
        output = ret.stdout.decode('utf-8')
        print(output)
        print("CMake build completed succesfully.")
    else:
        output = ret.stderr.decode('utf-8')
        print(output)
        print("CMake build with an error.")

    return errorcode


def NinjaBuild() -> int:
    errorcode: int = 0

    print("Starting ninja ...")

    try:
        ret = sub.run(["ninja", "-v"],
                      stdout=sub.PIPE,
                      stderr=sub.PIPE,
                      timeout=GENERATOR_TIMEOUT)
        errorcode = ret.returncode
    except Exception as ex:
        print("ERROR: Ninja failed.", str(ex))
        errorcode = 1

    if errorcode == 0:
        output = ret.stdout.decode('utf-8')
        print(output)
        print("ninja completed successfully.")
    else:
        output = ret.stderr.decode('utf-8')
        print(output)
        print("ninja failed with errors.")

    return errorcode


def main():
    # Start CMake to create build directory.
    ret = CMakeBuild(BUILD_DIR, BUILD_TYPE, BUILD_GENERATOR, ASM_TOOL_CHAIN)

    # If previous command was successful use ninja to build the output files.
    if ret == 0:
        os.chdir(BUILD_DIR)  # Change current directory to build directory.
        ret = NinjaBuild()  # Run Ninja-build
        os.chdir("..")  # go back to repository root directory

    shutil.rmtree(BUILD_DIR)  # delete cmake-build-bl2 directory.
    exit(ret)  # Exit program with return code.


if __name__ == "__main__":
    main()
