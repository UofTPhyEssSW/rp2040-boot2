# Installs the latest version of CMake

# 1. Find the version number for the latest release on download page
echo "Finding latest version of CMake ..."
CMAKE_VERSION=$(curl -s https://cmake.org/download/ | grep -Po '<h2[^>]*>\s*Latest Release \(\K([\d.]+)*(?=\)<\/h2>)')
#2. Download tar file
echo "Downloading CMake ..."
CMAKE_DL=https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-linux-x86_64.tar.gz
curl -Lo cmake-linux-x86_64.tar.gz "$CMAKE_DL"
#3. Extract Files
echo "Extracting and installing CMake ..."
mkdir /opt/cmake
tar xf cmake-linux-x86_64.tar.gz --strip-components=1 -C /opt/cmake
#4. Remove tar
echo "Removing tar for CMake ..."
rm cmake-linux-x86_64.tar.gz
