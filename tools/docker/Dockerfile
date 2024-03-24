# Fetch Ubuntu image
FROM ubuntu:latest
LABEL authors="Robert Morley"

# Copy bash scripts for installs.
RUN mkdir /setup_scripts

#ADD https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz /
#ADD https://github.com/Kitware/CMake/releases/download/v3.29.0/cmake-3.29.0-linux-x86_64.tar.gz /

COPY arm_gnu_toolchain.sh /setup_scripts/arm_gnu_toolchain.sh
COPY cmake_install.sh /setup_scripts/cmake_install.sh

# Install ARM GNU toolchain
#RUN mkdir /opt/gcc-arm-none-eabi \
#    && tar xf arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz --strip-components=1 -C /opt/gcc-arm-none-eabi \
#    && rm arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz

# Install CMake
#RUN mkdir /opt/cmake \
#    && tar xf cmake-3.29.0-linux-x86_64.tar.gz --strip-components=1 -C /opt/cmake \
#    && rm cmake-3.29.0-linux-x86_64.tar.gz

# Preinstall before running script.
RUN apt update && apt-get install -y curl && apt-get install -y xz-utils

# Install ARM GNU toolchain and CMake
RUN chmod u+x /setup_scripts/arm_gnu_toolchain.sh \
    && ./setup_scripts/arm_gnu_toolchain.sh

RUN chmod u+x /setup_scripts/cmake_install.sh \
    && ./setup_scripts/cmake_install.sh

ENV PATH="${PATH}:/opt/cmake/bin:/opt/gcc-arm-none-eabi/bin"


# Install Python and GNU GCC on image
RUN apt-get install -y python3  \
    && apt-get install -y build-essential

# Create Directory
RUN mkdir /tests && mkdir /setup


# Copy in Python Script
COPY test.py /tests/test.py
# Copy in our program under test
COPY main.c /tests/main.c

# Command that will be invoked when the container starts
ENTRYPOINT ["python3", "tests/test.py"]