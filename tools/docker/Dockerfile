#
# Docker image build command
#   > docker build -t rp2040-dev-img .
# Docker container create, two options; Command line and
#   > docker create -i -t --entrypoint="/bin/bash" --name rp2040-dev-cli rp2040-dev-img
#   > docker create -t -t --name rp2040-dev rp2040-dev-img
#
# Docker starts
#   First line is for testing second is for development.
#   > docker start -i rp2040-dev-cli
#   > docker start -i rp2040-dev
#
# TODO : Need to install SSH and set user credentials for remote login.
#
FROM ubuntu:latest
LABEL authors="Robert Morley"
# Make directory for install scripts
RUN mkdir /install_scripts && mkdir /repository && mkdir build
# Copy bash scripts for installs.
COPY scripts/arm_gnu_toolchain.sh /install_scripts/arm_gnu_toolchain.sh
COPY scripts/cmake_install.sh /install_scripts/cmake_install.sh
# Preinstall before running script.
RUN apt update && apt-get install -y curl xz-utils dos2unix
# Install ARM GNU toolchain and CMake
RUN dos2unix /install_scripts/arm_gnu_toolchain.sh \
    && chmod u+x /install_scripts/arm_gnu_toolchain.sh \
    && ./install_scripts/arm_gnu_toolchain.sh
# Install CMake and remove scripts
RUN dos2unix /install_scripts/cmake_install.sh \
    && chmod u+x /install_scripts/cmake_install.sh \
    && ./install_scripts/cmake_install.sh \
    && rm -r /install_scripts
# Make CMake and ARM GNU Toolchain global.
ENV PATH="${PATH}:/opt/cmake/bin:/opt/gcc-arm-none-eabi/bin"
# Install Python and GNU GCC on image
RUN apt-get install -y  \
    ssh python3  \
    build-essential \
    ninja-build \
    clang \
    && apt-get clean \
# Add
# Create Directory
RUN mkdir /setup && mkdir /project
# Command that will be invoked when the container starts
ENTRYPOINT ["/bash/bin"]

