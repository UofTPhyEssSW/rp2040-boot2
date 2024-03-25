# Installs the latest version of CMake

# 1. Find the version number for the latest release on download page
CMAKE_VERSION=$(curl -s https://cmake.org/download/ | grep -Po '<h2[^>]*>\s*Latest Release \(\K([\d.]+)*(?=\)<\/h2>)')
#2. Download tar file
CMAKE_DL=https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-linux-x86_64.tar.gz
curl -Lo cmake-linux-x86_64.tar.gz "$CMAKE_DL"
#3. Extract Files
mkdir /opt/cmake
tar xf cmake-linux-x86_64.tar.gz --strip-components=1 -C /opt/cmake
#4. Remove tar
rm cmake-linux-x86_64.tar.gz
