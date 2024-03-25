# Fetch Ubuntu image
FROM ubuntu:latest
LABEL authors="Robert Morley"
# Make directory for install scripts
RUN mkdir /install_scripts && mkdir /repository
# Copy bash scripts for installs.
COPY scripts/arm_gnu_toolchain.sh /install_scripts/arm_gnu_toolchain.sh
COPY scripts/cmake_install.sh /install_scripts/cmake_install.sh
# Preinstall before running script.
RUN apt update && apt-get install -y curl && apt-get install -y xz-utils
# Install ARM GNU toolchain and CMake
RUN chmod u+x /install_scripts/arm_gnu_toolchain.sh \
    && ./install_scripts/arm_gnu_toolchain.sh
# Install CMake and remove scripts
RUN chmod u+x /install_scripts/cmake_install.sh \
    && ./install_scripts/cmake_install.sh \
    && rm -r /install_scripts
# Make CMake and ARM GNU Toolchain global.
ENV PATH="${PATH}:/opt/cmake/bin:/opt/gcc-arm-none-eabi/bin"
# Install Python and GNU GCC on image
RUN apt-get install -y python3  \
    && apt-get install -y build-essential
# Create Directory
RUN mkdir /tests && mkdir /setup
# Command that will be invoked when the container starts
ENTRYPOINT ["/bash/bin"]

